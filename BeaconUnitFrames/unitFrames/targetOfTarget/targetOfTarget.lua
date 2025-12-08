---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT: BUFFeatureModule
local BUFToT = ns.NewFeatureModule("BUFToT")

BUFToT.configPath = "unitFrames.tot"

BUFToT.relativeToFrames = {
	FRAME = ns.Positionable.relativeToFrames.TOT_FRAME,
	PORTRAIT = ns.Positionable.relativeToFrames.TOT_PORTRAIT,
	NAME = ns.Positionable.relativeToFrames.TOT_NAME,
	HEALTH = ns.Positionable.relativeToFrames.TOT_HEALTH_BAR,
	POWER = ns.Positionable.relativeToFrames.TOT_POWER_BAR,
}

BUFToT.customRelativeToOptions = {
	[ns.Positionable.relativeToFrames.UI_PARENT] = ns.L["UIParent"],
	[BUFToT.relativeToFrames.FRAME] = ns.L["ToTFrame"],
	[BUFToT.relativeToFrames.PORTRAIT] = ns.L["ToTPortrait"],
	[BUFToT.relativeToFrames.NAME] = ns.L["ToTName"],
	[BUFToT.relativeToFrames.HEALTH] = ns.L["ToTHealthBar"],
	[BUFToT.relativeToFrames.POWER] = ns.L["ToTManaBar"],
}

BUFToT.customRelativeToSorting = {
	ns.Positionable.relativeToFrames.UI_PARENT,
	BUFToT.relativeToFrames.FRAME,
	BUFToT.relativeToFrames.PORTRAIT,
	BUFToT.relativeToFrames.NAME,
	BUFToT.relativeToFrames.HEALTH,
	BUFToT.relativeToFrames.POWER,
}

BUFToT.optionsTable = {
	type = "group",
	name = ns.L["ToTFrame"],
	handler = BUFToT,
	order = ns.BUFUnitFrames.optionsOrder.TOT,
	childGroups = "tree",
	disabled = BUFToT.IsDisabled,
	args = {
		title = {
			type = "header",
			name = ns.L["ToTFrame"],
			order = 0.001,
		},
		enable = {
			type = "toggle",
			name = ENABLE,
			set = "SetEnabled",
			disabled = false,
			get = "GetEnabled",
			order = 0.01,
		},
	},
}

---@class BUFDbSchema.UF.ToT
BUFToT.dbDefaults = {
	enabled = true,
}

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames
ns.dbDefaults.profile.unitFrames.tot = BUFToT.dbDefaults

ns.options.args.tot = BUFToT.optionsTable

BUFToT.optionsOrder = {
	FRAME = 1,
	PORTRAIT = 2,
	REPUTATION_BAR = 3,
	NAME = 4,
	LEVEL = 5,
	INDICATORS = 6,
	HEALTH = 7,
	POWER = 8,
	BUFFS = 9,
}

function BUFToT.IsDisabled()
	return not BUFToT:DbGet("enabled")
end

function BUFToT:SetEnabled(info, value)
	self:DbSet("enabled", value)
	if value then
		self:RefreshConfig()
	else
		StaticPopup_Show("BUF_RELOAD_UI")
	end
end

function BUFToT:GetEnabled(info)
	return self:DbGet("enabled")
end

function BUFToT:OnEnable()
	self.frame = TargetFrameToT
	if not self.frame then
		error("Target of Target frame not found")
	end
	self.healthBar = self.frame.HealthBar
	if not self.healthBar then
		error("Target of Target HealthBar not found")
	end
	self.manaBar = self.frame.ManaBar
	if not self.manaBar then
		error("Target of Target ManaBar not found")
	end
end

function BUFToT:RefreshConfig()
	if not self:GetEnabled() then
		return
	end
	-- if not self.initialized then
	-- 	local ClassificationCheckUpdater = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
	-- 	Mixin(ClassificationCheckUpdater, ns.BUFSecureHandler)

	-- 	-- TODO: Figure out if ToT needs this
	-- 	ClassificationCheckUpdater:SecureSetFrameRef("ToTargetHealthBar", self.healthBar)
	-- 	ClassificationCheckUpdater:SecureSetFrameRef("ToTargetManaBar", self.manaBar)

	-- 	ns.ToTClassificationCheckUpdater = ClassificationCheckUpdater
	-- end
	self.Frame:RefreshConfig()
	self.Portrait:RefreshConfig()
	self.Name:RefreshConfig()
	self.Health:RefreshConfig()
	self.Power:RefreshConfig()
	self.Buffs:RefreshConfig()

	if not self.initialized then
		self.initialized = true

		self:SecureHook(self.frame, "Update", function()
			-- Be careful in here, if you do anything insecure, it could cause lua errors during combat
			self.Health.foregroundHandler:RefreshConfig()
			self.Power.foregroundHandler:RefreshConfig()
		end)

		self:SecureHook("UnitFrameManaBar_UpdateType", function(manaBar)
			if manaBar == self.manaBar then
				self.Power.foregroundHandler:RefreshConfig()
				self.Health.foregroundHandler:RefreshConfig()
			end
		end)

		-- We won't end up actually triggering anything but keeping the code here
		-- in case something changes in the future.
		-- local ClassificationCheckUpdater = ns.ToTClassificationCheckUpdater

		-- ClassificationCheckUpdater:SetAttribute(
		-- 	"buf_restore_size_position",
		-- 	[[
		--     -- ToTHealthBar:RunAttribute("buf_restore_size")
		--     -- ToTManaBar:RunAttribute("buf_restore_size")

		--     -- ToTManaBar:RunAttribute("buf_restore_position")
		-- ]]
		-- )

		-- -- TODO: We may be able to hook into OnShow/OnHide as a secure trigger
		-- ClassificationCheckUpdater:SetAttribute(
		-- 	"_onattributechanged",
		-- 	[[
		--     self:RunAttribute("buf_restore_size_position")
		--     if name == "manual" then
		--         return
		--     end
		-- ]]
		-- )
	end
end

ns.BUFUnitFrames:RegisterFrame(BUFToT)

ns.BUFToT = BUFToT
