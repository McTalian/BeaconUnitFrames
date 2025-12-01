---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.CenterText: BUFFontString
local centerTextHandler = {
	configPath = "unitFrames.player.powerBar.centerText",
}

centerTextHandler.optionsTable = {
	type = "group",
	handler = centerTextHandler,
	name = ns.L["Center Text"],
	order = BUFPlayerPower.topGroupOrder.CENTER_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(centerTextHandler)

BUFPlayerPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.centerText = {
	anchorPoint = "CENTER",
	relativeTo = ns.DEFAULT,
	relativePoint = "CENTER",
	xOffset = 0,
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
ns.options.args.player.args.powerBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
	if not self.fontString then
		self.fontString = BUFPlayer.manaBar.ManaBarText
		self.demoText = "123k / 123k"
		self.defaultRelativeTo = BUFPlayer.manaBar
	end
	self:RefreshFontStringConfig()
end
