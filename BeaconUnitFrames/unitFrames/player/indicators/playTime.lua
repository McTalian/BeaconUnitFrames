---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.PlayTime: BUFScaleTexture
local BUFPlayerPlayTime = {
    configPath = "unitFrames.player.playTime",
}

BUFPlayerPlayTime.optionsTable = {
    type = "group",
    handler = BUFPlayerPlayTime,
    name = ns.L["Play Time"],
    order = BUFPlayerIndicators.optionsOrder.PLAY_TIME,
    args = {},
}

---@class BUFDbSchema.UF.Player.PlayTime
BUFPlayerPlayTime.dbDefaults = {
    scale = 1.0,
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = "TOPRIGHT",
    xOffset = -21,
    yOffset = -24,
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerPlayTime)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.playTime = BUFPlayerPlayTime.dbDefaults

ns.options.args.player.args.indicators.args.playTime = BUFPlayerPlayTime.optionsTable

function BUFPlayerPlayTime:RefreshConfig()
    if not self.initialized then
        self.initialized = true
        self.defaultRelativeTo = BUFPlayer.contentContextual
        self.texture = BUFPlayer.contentContextual.PlayerPlayTime
    end
    self:RefreshScaleTextureConfig()
end

BUFPlayerIndicators.PlayTime = BUFPlayerPlayTime
