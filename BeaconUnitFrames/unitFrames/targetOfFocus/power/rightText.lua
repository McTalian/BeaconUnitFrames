---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Power
local BUFToFocusPower = BUFToFocus.Power

---@class BUFToFocus.Power.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.tofocus.powerBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFToFocusPower.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)

BUFToFocusPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.ToFocus.Power
ns.dbDefaults.profile.unitFrames.tofocus.powerBar = ns.dbDefaults.profile.unitFrames.tofocus.powerBar

ns.dbDefaults.profile.unitFrames.tofocus.powerBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFToFocus.relativeToFrames.POWER,
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

ns.options.args.tofocus.args.powerBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.fontString = BUFToFocus.manaBar.RightText
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end
