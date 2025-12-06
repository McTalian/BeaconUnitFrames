---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet: BUFFeatureModule
local BUFPet = ns.NewFeatureModule("BUFPet")

BUFPet.relativeToFrames = {
	FRAME = ns.Positionable.relativeToFrames.PET_FRAME,
	PORTRAIT = ns.Positionable.relativeToFrames.PET_PORTRAIT,
	NAME = ns.Positionable.relativeToFrames.PET_NAME,
	HEALTH = ns.Positionable.relativeToFrames.PET_HEALTH_BAR,
	POWER = ns.Positionable.relativeToFrames.PET_POWER_BAR,
	CASTING = ns.Positionable.relativeToFrames.PET_CAST_BAR,
}

BUFPet.customRelativeToOptions = {
	[ns.Positionable.relativeToFrames.UI_PARENT] = ns.L["UIParent"],
	[BUFPet.relativeToFrames.FRAME] = HUD_EDIT_MODE_PET_FRAME_LABEL,
	[BUFPet.relativeToFrames.PORTRAIT] = ns.L["PetPortrait"],
	[BUFPet.relativeToFrames.NAME] = ns.L["PetName"],
	[BUFPet.relativeToFrames.HEALTH] = ns.L["PetHealthBar"],
	[BUFPet.relativeToFrames.POWER] = ns.L["PetManaBar"],
}

BUFPet.customRelativeToSorting = {
	ns.Positionable.relativeToFrames.UI_PARENT,
	BUFPet.relativeToFrames.FRAME,
	BUFPet.relativeToFrames.PORTRAIT,
	BUFPet.relativeToFrames.NAME,
	BUFPet.relativeToFrames.HEALTH,
	BUFPet.relativeToFrames.POWER,
}

BUFPet.optionsTable = {
	type = "group",
	name = HUD_EDIT_MODE_PET_FRAME_LABEL,
	order = ns.BUFUnitFrames.optionsOrder.PET,
	childGroups = "tree",
	disabled = function()
		return not ns.db.profile.unitFrames.pet.enabled
	end,
	args = {
		title = {
			type = "header",
			name = HUD_EDIT_MODE_PET_FRAME_LABEL,
			order = 0.001,
		},
		enable = {
			type = "toggle",
			name = ENABLE,
			set = function(info, value)
				ns.db.profile.unitFrames.pet.enabled = value
				if value then
					BUFPet:RefreshConfig()
				else
					StaticPopup_Show("BUF_RELOAD_UI")
				end
			end,
			disabled = false,
			get = function(info)
				return ns.db.profile.unitFrames.pet.enabled
			end,
			order = 0.01,
		},
	},
}

---@class BUFDbSchema.UF.Pet
BUFPet.dbDefaults = {
	enabled = true,
}

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames
ns.dbDefaults.profile.unitFrames.pet = BUFPet.dbDefaults

ns.options.args.pet = BUFPet.optionsTable

BUFPet.optionsOrder = {
	FRAME = 1,
	PORTRAIT = 2,
	NAME = 3,
	LEVEL = 4,
	INDICATORS = 5,
	HEALTH = 6,
	POWER = 7,
	CLASS_RESOURCES = 8,
}

function BUFPet:OnEnable()
	self.frame = PetFrame
	self.healthBar = PetFrameHealthBar
	self.manaBar = PetFrameManaBar
end

function BUFPet:CombatSafeRefresh()
	-- Refresh the config that does not require a secure environment
	self.Portrait:RefreshConfig()
	self.Name:RefreshConfig()
	self.Indicators:RefreshConfig()
	self.Health:RefreshConfig()
	self.Power:RefreshConfig()
end

function BUFPet:RefreshConfig(_eName)
	if not ns.db.profile.unitFrames.pet.enabled then
		return
	end

	if InCombatLockdown() then
		if not self.regenRegistered then
			self.regenRegistered = true
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "RefreshConfig")
		end
		self:CombatSafeRefresh()
		return
	else
		if self.regenRegistered then
			self.regenRegistered = false
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end
	end

	self.Frame:RefreshConfig()
	self:CombatSafeRefresh()

	if not self.initialized then
		self.initialized = true

		self:RegisterEvent("PET_UI_UPDATE", "RefreshConfig")

		if not self:IsHooked(PetFrame, "Update") then
			self:SecureHook(PetFrame, "Update", function()
				self:RefreshConfig()
			end)
		end

		self:SecureHook("PlayerFrame_UpdateArt", function()
			self:RefreshConfig()
		end)
	end
end

ns.BUFPet = BUFPet
