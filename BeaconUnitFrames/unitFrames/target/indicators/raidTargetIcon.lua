---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.RaidTargetIcon: BUFScaleTexture
local BUFTargetRaidTargetIcon = {
	configPath = "unitFrames.target.raidTargetIcon",
}

BUFTargetRaidTargetIcon.optionsTable = {
	type = "group",
	handler = BUFTargetRaidTargetIcon,
	name = ns.L["Raid Target Icon"],
	order = BUFTargetIndicators.optionsOrder.RAID_TARGET_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Target.RaidTargetIcon
BUFTargetRaidTargetIcon.dbDefaults = {
	scale = 1,
	anchorPoint = "CENTER",
	relativeTo = BUFTarget.relativeToFrames.PORTRAIT,
	relativePoint = "TOP",
	xOffset = 0,
	yOffset = 0,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetRaidTargetIcon)

ns.options.args.target.args.indicators.args.raidTargetIcon = BUFTargetRaidTargetIcon.optionsTable

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.raidTargetIcon = BUFTargetRaidTargetIcon.dbDefaults

function BUFTargetRaidTargetIcon:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.texture = BUFTarget.contentContextual.RaidTargetIcon
	end

	self:RefreshScaleTextureConfig()
end

BUFTargetIndicators.RaidTargetIcon = BUFTargetRaidTargetIcon
