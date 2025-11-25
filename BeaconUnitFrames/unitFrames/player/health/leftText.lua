---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.LeftText: BUFConfigHandler, BUFFontString
local leftTextHandler = {
    configPath = "unitFrames.player.healthBar.leftText",
}

leftTextHandler.optionsTable = {
    type = "group",
    handler = leftTextHandler,
    name = ns.L["Left Text"],
    order = BUFPlayerHealth.topGroupOrder.LEFT_TEXT,
    args = {}
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFPlayerHealth.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar

ns.dbDefaults.profile.unitFrames.player.healthBar.leftText = {
    anchorPoint = "LEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
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

ns.options.args.unitFrames.args.player.args.healthBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = BUFPlayer.healthBarContainer.LeftText
    end
    self:RefreshFontStringConfig()
end
