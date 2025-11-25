---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Level: BUFConfigHandler, BUFFontString
local BUFPlayerLevel = {
    configPath = "unitFrames.player.level",
}

BUFPlayerLevel.optionsTable = {
    type = "group",
    handler = BUFPlayerLevel,
    name = LEVEL,
    order = BUFPlayer.optionsOrder.LEVEL,
    args = {}
}

ns.BUFFontString:ApplyMixin(BUFPlayerLevel)

BUFPlayer.Level = BUFPlayerLevel

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Level
ns.dbDefaults.profile.unitFrames.player.level = {
    anchorPoint = "TOPRIGHT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = -24.5,
    yOffset = -28,
    useFontObjects = true,
    fontObject = "GameFontNormalSmall",
    fontColor = { NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.a },
    fontFace = "Friz Quadrata TT",
    fontSize = 12,
    fontFlags = {
		[ns.FontFlags.OUTLINE] = false,
		[ns.FontFlags.THICKOUTLINE] = false,
		[ns.FontFlags.MONOCHROME] = false,
	},
	fontShadowColor = { 0, 0, 0, 1 },
	fontShadowOffsetX = 1,
	fontShadowOffsetY = -1,
}

ns.options.args.unitFrames.args.player.args.level = BUFPlayerLevel.optionsTable

function BUFPlayerLevel:RefreshConfig()
    if not self.fontString then
        self.fontString = PlayerLevelText
    end
    self:RefreshFontStringConfig()
end
