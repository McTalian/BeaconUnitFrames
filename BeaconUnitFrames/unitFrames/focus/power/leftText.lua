---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Power
local BUFFocusPower = BUFFocus.Power

---@class BUFFocus.Power.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.focus.powerBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFFocusPower.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFFocusPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Focus.Power
ns.dbDefaults.profile.unitFrames.focus.powerBar = ns.dbDefaults.profile.unitFrames.focus.powerBar

ns.dbDefaults.profile.unitFrames.focus.powerBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFFocus.relativeToFrames.POWER,
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

ns.options.args.focus.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.fontString = BUFFocus.manaBar.LeftText
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end
