---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Level: BUFFontString
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

ns.options.args.player.args.level = BUFPlayerLevel.optionsTable

function BUFPlayerLevel:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        self.fontString = PlayerLevelText
        self.defaultRelativeTo = BUFPlayer.contentMain
        self.defaultRelativePoint = "TOPRIGHT"

        local player = BUFPlayer

        if not player:IsHooked("PlayerFrame_UpdateLevel") then
            player:SecureHook("PlayerFrame_UpdateLevel", function(f)
                self:UpdateFontColor()
            end)
        end
    end
    self:RefreshFontStringConfig()
end
