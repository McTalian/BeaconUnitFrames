---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Power
local BUFFocusPower = BUFFocus.Power

---@class BUFFocus.Power.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.focus.powerBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFFocusPower.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)

BUFFocusPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Focus.Power
ns.dbDefaults.profile.unitFrames.focus.powerBar = ns.dbDefaults.profile.unitFrames.focus.powerBar

ns.dbDefaults.profile.unitFrames.focus.powerBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFFocus.relativeToFrames.POWER,
	relativePoint = "RIGHT",
	xOffset = -13,
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

ns.options.args.focus.args.powerBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.fontString = BUFFocus.manaBar.RightText
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end
