---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Health
local BUFFocusHealth = BUFFocus.Health

---@class BUFFocus.Health.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.focus.healthBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFFocusHealth.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFFocusHealth.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Focus.Health
ns.dbDefaults.profile.unitFrames.focus.healthBar = ns.dbDefaults.profile.unitFrames.focus.healthBar

ns.dbDefaults.profile.unitFrames.focus.healthBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFFocus.relativeToFrames.HEALTH,
	relativePoint = "LEFT",
	xOffset = 2,
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

ns.options.args.focus.args.healthBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.fontString = BUFFocus.healthBarContainer.LeftText
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end
