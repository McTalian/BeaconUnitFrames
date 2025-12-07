---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.target.powerBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFTargetPower.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFTargetPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFTarget.relativeToFrames.POWER,
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

ns.options.args.target.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.fontString = BUFTarget.manaBar.LeftText
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end
