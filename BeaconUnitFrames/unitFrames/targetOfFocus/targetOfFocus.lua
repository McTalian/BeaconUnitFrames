---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus: BUFFeatureModule
local BUFToFocus = ns.NewFeatureModule("BUFToFocus")

BUFToFocus.configPath = "unitFrames.tofocus"

BUFToFocus.relativeToFrames = {
	FRAME = ns.Positionable.relativeToFrames.TOFOCUS_FRAME,
	PORTRAIT = ns.Positionable.relativeToFrames.TOFOCUS_PORTRAIT,
	NAME = ns.Positionable.relativeToFrames.TOFOCUS_NAME,
	HEALTH = ns.Positionable.relativeToFrames.TOFOCUS_HEALTH_BAR,
	POWER = ns.Positionable.relativeToFrames.TOFOCUS_POWER_BAR,
}

BUFToFocus.customRelativeToOptions = {
	[ns.Positionable.relativeToFrames.UI_PARENT] = ns.L["UIParent"],
	[BUFToFocus.relativeToFrames.FRAME] = ns.L["ToFocusFrame"],
	[BUFToFocus.relativeToFrames.PORTRAIT] = ns.L["ToFocusPortrait"],
	[BUFToFocus.relativeToFrames.NAME] = ns.L["ToFocusName"],
	[BUFToFocus.relativeToFrames.HEALTH] = ns.L["ToFocusHealthBar"],
	[BUFToFocus.relativeToFrames.POWER] = ns.L["ToFocusManaBar"],
}

BUFToFocus.customRelativeToSorting = {
	ns.Positionable.relativeToFrames.UI_PARENT,
	BUFToFocus.relativeToFrames.FRAME,
	BUFToFocus.relativeToFrames.PORTRAIT,
	BUFToFocus.relativeToFrames.NAME,
	BUFToFocus.relativeToFrames.HEALTH,
	BUFToFocus.relativeToFrames.POWER,
}

BUFToFocus.optionsTable = {
	type = "group",
	name = ns.L["ToFocusFrame"],
	handler = BUFToFocus,
	order = ns.BUFUnitFrames.optionsOrder.TOFOCUS,
	childGroups = "tree",
	disabled = BUFToFocus.IsDisabled,
	args = {
		title = {
			type = "header",
			name = ns.L["ToFocusFrame"],
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

---@class BUFDbSchema.UF.ToFocus
BUFToFocus.dbDefaults = {
	enabled = true,
}

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames
ns.dbDefaults.profile.unitFrames.tofocus = BUFToFocus.dbDefaults

ns.options.args.tofocus = BUFToFocus.optionsTable

BUFToFocus.optionsOrder = {
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

function BUFToFocus.IsDisabled()
	return not BUFToFocus:DbGet("enabled")
end

function BUFToFocus:SetEnabled(info, value)
	self:DbSet("enabled", value)
	if value then
		self:RefreshConfig()
	else
		StaticPopup_Show("BUF_RELOAD_UI")
	end
end

function BUFToFocus:GetEnabled(info)
	return self:DbGet("enabled")
end

function BUFToFocus:OnEnable()
	self.frame = FocusFrameToT
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

function BUFToFocus:RefreshConfig()
	if not self:GetEnabled() then
		return
	end
	-- if not self.initialized then
	-- 	local ClassificationCheckUpdater = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
	-- 	Mixin(ClassificationCheckUpdater, ns.BUFSecureHandler)

	-- 	-- TODO: Figure out if ToFocus needs this
	-- 	ClassificationCheckUpdater:SecureSetFrameRef("ToFocusHealthBar", self.healthBar)
	-- 	ClassificationCheckUpdater:SecureSetFrameRef("ToFocusManaBar", self.manaBar)

	-- 	ns.ToFocusClassificationCheckUpdater = ClassificationCheckUpdater
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
		-- local ClassificationCheckUpdater = ns.ToFocusClassificationCheckUpdater

		-- ClassificationCheckUpdater:SetAttribute(
		-- 	"buf_restore_size_position",
		-- 	[[
		--     -- ToFocusHealthBar:RunAttribute("buf_restore_size")
		--     -- ToFocusManaBar:RunAttribute("buf_restore_size")

		--     -- ToFocusManaBar:RunAttribute("buf_restore_position")
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

ns.BUFUnitFrames:RegisterFrame(BUFToFocus)

ns.BUFToFocus = BUFToFocus
