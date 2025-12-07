---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.RaidTargetIcon: BUFScaleTexture
local BUFFocusRaidTargetIcon = {
	configPath = "unitFrames.focus.raidTargetIcon",
}

BUFFocusRaidTargetIcon.optionsTable = {
	type = "group",
	handler = BUFFocusRaidTargetIcon,
	name = ns.L["Raid Target Icon"],
	order = BUFFocusIndicators.optionsOrder.RAID_TARGET_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Focus.RaidTargetIcon
BUFFocusRaidTargetIcon.dbDefaults = {
	scale = 1,
	anchorPoint = "CENTER",
	relativeTo = BUFFocus.relativeToFrames.PORTRAIT,
	relativePoint = "TOP",
	xOffset = 0,
	yOffset = 0,
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusRaidTargetIcon)

ns.options.args.focus.args.indicators.args.raidTargetIcon = BUFFocusRaidTargetIcon.optionsTable

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.raidTargetIcon = BUFFocusRaidTargetIcon.dbDefaults

function BUFFocusRaidTargetIcon:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.RaidTargetIcon
	end

	self:RefreshScaleTextureConfig()
end

BUFFocusIndicators.RaidTargetIcon = BUFFocusRaidTargetIcon
