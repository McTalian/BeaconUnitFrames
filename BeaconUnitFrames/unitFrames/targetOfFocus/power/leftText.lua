---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Power
local BUFToFocusPower = BUFToFocus.Power

---@class BUFToFocus.Power.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.tofocus.powerBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFToFocusPower.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFToFocusPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.ToFocus.Power
ns.dbDefaults.profile.unitFrames.tofocus.powerBar = ns.dbDefaults.profile.unitFrames.tofocus.powerBar

ns.dbDefaults.profile.unitFrames.tofocus.powerBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFToFocus.relativeToFrames.POWER,
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

ns.options.args.tofocus.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.fontString = BUFToFocus.manaBar.LeftText
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end
