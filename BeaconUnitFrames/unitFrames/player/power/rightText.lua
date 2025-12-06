---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.player.powerBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFPlayerPower.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)

BUFPlayerPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFPlayer.relativeToFrames.POWER,
	relativePoint = "RIGHT",
	xOffset = -2,
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

ns.options.args.player.args.powerBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.fontString = BUFPlayer.manaBar.RightText
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end
