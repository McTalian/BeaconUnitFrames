---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.target.healthBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFTargetHealth.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)

BUFTargetHealth.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFTarget.relativeToFrames.HEALTH,
	relativePoint = "RIGHT",
	xOffset = -5,
	yOffset = 0,
	useFontObjects = true,
	fontObject = "TextStatusBarText",
	fontColor = { 1, 1, 1, 1 },
	fontFace = "Friz Quadrata TT",
	fontSize = 10,
	fontFlags = {
		[ns.FontFlags.OUTLINE] = false,
		[ns.FontFlags.THICKOUTLINE] = false,
		[ns.FontFlags.MONOCHROME] = false,
	},
	fontShadowColor = { 0, 0, 0, 1 },
	fontShadowOffsetX = 1,
	fontShadowOffsetY = -1,
}

ns.options.args.target.args.healthBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.fontString = BUFTarget.healthBarContainer.RightText
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end
