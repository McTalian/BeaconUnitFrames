---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.player.powerBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFPlayerPower.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFPlayerPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFPlayer.relativeToFrames.POWER,
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

ns.options.args.player.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.fontString = BUFPlayer.manaBar.LeftText
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end
