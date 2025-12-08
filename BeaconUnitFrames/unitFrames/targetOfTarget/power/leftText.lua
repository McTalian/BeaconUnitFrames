---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Power
local BUFToTPower = BUFToT.Power

---@class BUFToT.Power.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.tot.powerBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFToTPower.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFToTPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.ToT.Power
ns.dbDefaults.profile.unitFrames.tot.powerBar = ns.dbDefaults.profile.unitFrames.tot.powerBar

ns.dbDefaults.profile.unitFrames.tot.powerBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFToT.relativeToFrames.POWER,
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

ns.options.args.tot.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.fontString = BUFToT.manaBar.LeftText
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end
