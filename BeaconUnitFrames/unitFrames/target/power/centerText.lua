---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.CenterText: BUFConfigHandler, BUFFontString
local centerTextHandler = {
    configPath = "unitFrames.target.powerBar.centerText",
}

ns.BUFFontString:ApplyMixin(centerTextHandler)

BUFTargetPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.centerText = {
    anchorPoint = "CENTER",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = -4,
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

local centerText = {
    type = "group",
    handler = centerTextHandler,
    name = ns.L["Center Text"],
    order = BUFTargetPower.topGroupOrder.CENTER_TEXT,
    args = {}
}

ns.AddFontStringOptions(centerText.args)

ns.options.args.unitFrames.args.target.args.powerBar.args.centerText = centerText

function centerTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = BUFTarget.manaBar.ManaBarText
    end
    self:RefreshFontStringConfig()
end
