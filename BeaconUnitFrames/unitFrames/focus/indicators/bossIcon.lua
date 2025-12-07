---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.BossIcon: BUFScaleTexture
local BUFFocusBossIcon = {
	configPath = "unitFrames.focus.bossIcon",
}

BUFFocusBossIcon.optionsTable = {
	type = "group",
	handler = BUFFocusBossIcon,
	name = ns.L["Boss Icon"],
	order = BUFFocusIndicators.optionsOrder.BOSS_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Focus.BossIcon
BUFFocusBossIcon.dbDefaults = {
	anchorPoint = "CENTER",
	relativeTo = BUFFocus.relativeToFrames.PORTRAIT,
	relativePoint = "BOTTOM",
	xOffset = 0,
	yOffset = 0,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusBossIcon)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.bossIcon = BUFFocusBossIcon.dbDefaults

ns.options.args.focus.args.indicators.args.bossIcon = BUFFocusBossIcon.optionsTable

function BUFFocusBossIcon:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.BossIcon
	end
	self:RefreshScaleTextureConfig()
end

BUFFocusIndicators.BossIcon = BUFFocusBossIcon
