---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.LeftText: BUFConfigHandler, BUFFontString
local leftTextHandler = {
    configPath = "unitFrames.player.powerBar.leftText",
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFPlayerPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.leftText = {
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

local leftText = {
    type = "group",
    handler = leftTextHandler,
    name = ns.L["Left Text"],
    order = BUFPlayerPower.topGroupOrder.LEFT_TEXT,
    args = {}
}

ns.AddFontStringOptions(leftText.args)

ns.options.args.unitFrames.args.player.args.powerBar.args.leftText = leftText

function leftTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = BUFPlayer.manaBar.LeftText
    end
    self:RefreshFontStringConfig()
end
