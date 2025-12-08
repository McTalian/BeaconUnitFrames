---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Power
local BUFToTPower = BUFToT.Power

---@class BUFToT.Power.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.tot.powerBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFToTPower.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)

BUFToTPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.ToT.Power
ns.dbDefaults.profile.unitFrames.tot.powerBar = ns.dbDefaults.profile.unitFrames.tot.powerBar

ns.dbDefaults.profile.unitFrames.tot.powerBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFToT.relativeToFrames.POWER,
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

ns.options.args.tot.args.powerBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.fontString = BUFToT.manaBar.RightText
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end
