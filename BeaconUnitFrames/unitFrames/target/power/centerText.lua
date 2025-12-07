---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.CenterText: BUFFontString
local centerTextHandler = {
	configPath = "unitFrames.target.powerBar.centerText",
}

centerTextHandler.optionsTable = {
	type = "group",
	handler = centerTextHandler,
	name = ns.L["Center Text"],
	order = BUFTargetPower.topGroupOrder.CENTER_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(centerTextHandler)

BUFTargetPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.centerText = {
	anchorPoint = "CENTER",
	relativeTo = BUFTarget.relativeToFrames.POWER,
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

ns.options.args.target.args.powerBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.fontString = BUFTarget.manaBar.ManaBarText
		self.demoText = "123k / 123k"
	end
	self:RefreshFontStringConfig()
end
