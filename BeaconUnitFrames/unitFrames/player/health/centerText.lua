---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.CenterText: BUFConfigHandler, BUFFontString
local centerTextHandler = {
    configPath = "unitFrames.player.healthBar.centerText",
}

centerTextHandler.optionsTable = {
    type = "group",
    handler = centerTextHandler,
    name = ns.L["Center Text"],
    order = BUFPlayerHealth.topGroupOrder.CENTER_TEXT,
    args = {}
}

ns.BUFFontString:ApplyMixin(centerTextHandler)

BUFPlayerHealth.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar

ns.dbDefaults.profile.unitFrames.player.healthBar.centerText = {
    anchorPoint = "CENTER",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
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

ns.options.args.player.args.healthBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = BUFPlayer.healthBarContainer.HealthBarText
        self.demoText = "123k / 123k"
        self.defaultRelativeTo = BUFPlayer.healthBarContainer
        self.defaultRelativePoint = "CENTER"
    end
    self:RefreshFontStringConfig()
end
