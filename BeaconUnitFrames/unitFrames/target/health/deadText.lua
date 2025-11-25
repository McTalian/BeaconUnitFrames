---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.DeadText: BUFConfigHandler, BUFFontString
local deadTextHandler = {
    configPath = "unitFrames.target.healthBar.deadText",
}

deadTextHandler.optionsTable = {
    type = "group",
    handler = deadTextHandler,
    name = ns.L["Dead Text"],
    order = BUFTargetHealth.topGroupOrder.DEAD_TEXT,
    args = {}
}

ns.BUFFontString:ApplyMixin(deadTextHandler)

BUFTargetHealth.deadTextHandler = deadTextHandler

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.deadText = {
    anchorPoint = "CENTER",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 0,
    yOffset = 0,
    useFontObjects = true,
    fontObject = "GameFontNormalSmall",
    fontColor = { 1, 0, 0, 1 },
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

ns.options.args.unitFrames.args.target.args.healthBar.args.deadText = deadTextHandler.optionsTable

function deadTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = BUFTarget.healthBarContainer.DeadText
    end
    self:RefreshFontStringConfig()
end
