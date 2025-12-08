---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Power
local BUFToTPower = BUFToT.Power

---@class BUFToT.Power.CenterText: BUFFontString
local centerTextHandler = {
	configPath = "unitFrames.tot.powerBar.centerText",
}

centerTextHandler.optionsTable = {
	type = "group",
	handler = centerTextHandler,
	name = ns.L["Center Text"],
	order = BUFToTPower.topGroupOrder.CENTER_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(centerTextHandler)

BUFToTPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.ToT.Power
ns.dbDefaults.profile.unitFrames.tot.powerBar = ns.dbDefaults.profile.unitFrames.tot.powerBar

ns.dbDefaults.profile.unitFrames.tot.powerBar.centerText = {
	anchorPoint = "CENTER",
	relativeTo = BUFToT.relativeToFrames.POWER,
	relativePoint = "CENTER",
	xOffset = -4,
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

ns.options.args.tot.args.powerBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.fontString = BUFToT.manaBar.ManaBarText
		self.demoText = "123k / 123k"
	end
	self:RefreshFontStringConfig()
end
