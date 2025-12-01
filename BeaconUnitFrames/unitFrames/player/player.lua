---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer: AceModule, AceHook-3.0
local BUFPlayer = ns.BUF:NewModule("BUFPlayer", "AceHook-3.0")

ns.BUFPlayer = BUFPlayer

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = {
	enabled = true,
}

ns.options.args.player = {
	type = "group",
	name = HUD_EDIT_MODE_PLAYER_FRAME_LABEL,
	order = ns.BUFUnitFrames.optionsOrder.PLAYER,
	childGroups = "tree",
	disabled = function()
		return not ns.db.profile.unitFrames.player.enabled
	end,
	args = {
		title = {
			type = "header",
			name = HUD_EDIT_MODE_PLAYER_FRAME_LABEL,
			order = 0.001,
		},
		enable = {
			type = "toggle",
			name = ENABLE,
			set = function(info, value)
				ns.db.profile.unitFrames.target.enabled = value
				if value then
					BUFPlayer:RefreshConfig()
				else
					StaticPopup_Show("BUF_RELOAD_UI")
				end
			end,
			disabled = false,
			get = function(info)
				return ns.db.profile.unitFrames.target.enabled
			end,
			order = 0.01,
		},
	},
}

BUFPlayer.optionsOrder = {
	FRAME = 1,
	PORTRAIT = 2,
	NAME = 3,
	LEVEL = 4,
	INDICATORS = 5,
	HEALTH = 6,
	POWER = 7,
	CLASS_RESOURCES = 8,
}

function BUFPlayer:OnEnable()
	self.frame = PlayerFrame
	self.container = self.frame.PlayerFrameContainer
	self.content = self.frame.PlayerFrameContent
	self.contentMain = self.content.PlayerFrameContentMain
	self.contentContextual = PlayerFrame_GetPlayerFrameContentContextual()
	self.restLoop = self.contentContextual.PlayerRestLoop
	self.healthBarContainer = PlayerFrame_GetHealthBarContainer()
	self.healthBar = PlayerFrame_GetHealthBar()
	self.manaBarArea = self.contentMain.ManaBarArea
	self.manaBar = PlayerFrame_GetManaBar()
	self.altPowerBar = PlayerFrame_GetAlternatePowerBar()
end

function BUFPlayer:RefreshConfig()
	if not ns.db.profile.unitFrames.player.enabled then
		return
	end
	if not self.initialized then
		local ArtUpdater = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
		Mixin(ArtUpdater, ns.BUFSecureHandler)

		-- Kudos to Spyro from the WoWUIDev Discord for figuring out repositioning/resizing
		-- on entering/exiting vehicles
		ArtUpdater:SecureSetFrameRef("AlternatePowerBarArea", PlayerFrameAlternatePowerBarArea)
		ArtUpdater:SecureSetFrameRef("PlayerHealthBarContainer", PlayerFrame_GetHealthBarContainer())
		ArtUpdater:SecureSetFrameRef("PlayerHealthBar", PlayerFrame_GetHealthBar())
		ArtUpdater:SecureSetFrameRef("PlayerManaBar", PlayerFrame_GetManaBar())

		ns.PlayerArtUpdater = ArtUpdater
	end

	self.Frame:RefreshConfig()
	self.Portrait:RefreshConfig()
	self.Name:RefreshConfig()
	self.Level:RefreshConfig()
	self.Indicators:RefreshConfig()
	self.Health:RefreshConfig()
	self.Power:RefreshConfig()
	self.ClassResources:RefreshConfig()

	if not self.initialized then
		self.initialized = true

		local ArtUpdater = ns.PlayerArtUpdater

		ArtUpdater:SetAttribute(
			"buf_restore_size_position",
			[[
            PlayerHealthBarContainer:RunAttribute("buf_restore_size")
            PlayerHealthBar:RunAttribute("buf_restore_size")
            PlayerManaBar:RunAttribute("buf_restore_size")

            PlayerHealthBarContainer:RunAttribute("buf_restore_position")
            PlayerManaBar:RunAttribute("buf_restore_position")
        ]]
		)

		ArtUpdater:SetAttribute(
			"_onattributechanged",
			[[
            self:RunAttribute("buf_restore_size_position")
            if name == "manual" then
                return
            end

            -- Preparing the AlternatePowerBarArea to make it trigger OnShow/OnHide
            if UsingAltPowerBar then
                AlternatePowerBarArea:Hide()
            else
                AlternatePowerBarArea:Show()
            end
        ]]
		)

		-- Manual trigger by pressing SHIFT+ALT in case the other triggers fail
		RegisterAttributeDriver(ArtUpdater, "manual", "[mod:shift,mod:alt] 1; 0")

		-- Triggers that check for the vehicle existence
		-- This works to restore the PlayerFrame's components when entering a vehicle
		RegisterAttributeDriver(ArtUpdater, "vehicleunit", "[@vehicle,exists] 1; 0")
		RegisterAttributeDriver(ArtUpdater, "vehiclestate", "[vehicleui][overridebar][possessbar] 1; 0")

		-- Triggers by hooking the PlayerFrameAlternatePowerBarArea which is hidden by the base UI when mounting
		-- a vehicle. This works to securely restore the PlayerFrame's components when leaving a vehicle
		SecureHandlerWrapScript(
			PlayerFrameAlternatePowerBarArea,
			"OnHide",
			ArtUpdater,
			[[
            control:RunAttribute("buf_restore_size_position")
        ]]
		)
		SecureHandlerWrapScript(
			PlayerFrameAlternatePowerBarArea,
			"OnShow",
			ArtUpdater,
			[[
            control:RunAttribute("buf_restore_size_position")
        ]]
		)

		ArtUpdater:SecureExecute([[ UsingAltPowerBar = %s ]], tostring(PlayerFrame.activeAlternatePowerBar ~= nil))
		self:SecureHook("PlayerFrame_UpdateArt", function()
			if not InCombatLockdown() then
				ArtUpdater:SecureExecute(
					[[
                    UsingAltPowerBar = %s
                    self:RunAttribute("buf_restore_size_position")
                ]],
					tostring(PlayerFrame.activeAlternatePowerBar ~= nil)
				)
			else
				local frame = CreateFrame("Frame")
				frame:RegisterEvent("PLAYER_REGEN_ENABLED")
				frame:SetScript("OnEvent", function(self)
					BUFPlayer:RefreshConfig()
					self:UnregisterEvent("PLAYER_REGEN_ENABLED")
				end)
			end
			self.Health.foregroundHandler:RefreshConfig()
			self.Power.foregroundHandler:RefreshConfig()
			self.Power:SetUnprotectedSize()
			self.Indicators:RefreshConfig()
			self.ClassResources:RefreshConfig()
		end)
	end
end
