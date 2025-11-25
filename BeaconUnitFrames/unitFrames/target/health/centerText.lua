---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.CenterText: BUFConfigHandler, BUFFontString
local centerTextHandler = {
    configPath = "unitFrames.target.healthBar.centerText",
}

centerTextHandler.optionsTable = {
    type = "group",
    handler = centerTextHandler,
    name = ns.L["Center Text"],
    order = BUFTargetHealth.topGroupOrder.CENTER_TEXT,
    args = {}
}

ns.BUFFontString:ApplyMixin(centerTextHandler)

BUFTargetHealth.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.centerText = {
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

ns.options.args.unitFrames.args.target.args.healthBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = BUFTarget.healthBarContainer.HealthBarText
    end
    self:RefreshFontStringConfig()
end
