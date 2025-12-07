---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.BossIcon: BUFScaleTexture
local BUFTargetBossIcon = {
	configPath = "unitFrames.target.bossIcon",
}

BUFTargetBossIcon.optionsTable = {
	type = "group",
	handler = BUFTargetBossIcon,
	name = ns.L["Boss Icon"],
	order = BUFTargetIndicators.optionsOrder.BOSS_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Target.BossIcon
BUFTargetBossIcon.dbDefaults = {
	anchorPoint = "CENTER",
	relativeTo = BUFTarget.relativeToFrames.PORTRAIT,
	relativePoint = "BOTTOM",
	xOffset = 0,
	yOffset = 0,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetBossIcon)

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.bossIcon = BUFTargetBossIcon.dbDefaults

ns.options.args.target.args.indicators.args.bossIcon = BUFTargetBossIcon.optionsTable

function BUFTargetBossIcon:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.texture = BUFTarget.contentContextual.BossIcon
	end
	self:RefreshScaleTextureConfig()
end

BUFTargetIndicators.BossIcon = BUFTargetBossIcon
