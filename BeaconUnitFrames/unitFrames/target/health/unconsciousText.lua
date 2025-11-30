---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.UnconsciousText: BUFConfigHandler, BUFFontString
local unconsciousTextHandler = {
    configPath = "unitFrames.target.healthBar.unconsciousText",
}

unconsciousTextHandler.optionsTable = {
    type = "group",
    handler = unconsciousTextHandler,
    name = ns.L["Unconscious Text"],
    order = BUFTargetHealth.topGroupOrder.UNCONSCIOUS_TEXT,
    args = {}
}

ns.BUFFontString:ApplyMixin(unconsciousTextHandler)

BUFTargetHealth.unconsciousTextHandler = unconsciousTextHandler

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.unconsciousText = {
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

ns.options.args.target.args.healthBar.args.unconsciousText = unconsciousTextHandler.optionsTable

function unconsciousTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = BUFTarget.healthBarContainer.UnconsciousText
        self.defaultRelativeTo = BUFTarget.healthBar
        self.defaultRelativePoint = "CENTER"
    end
    self:RefreshFontStringConfig()
end
