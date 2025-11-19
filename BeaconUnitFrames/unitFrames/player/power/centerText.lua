---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.CenterText: BUFConfigHandler, Positionable, Fontable, Anchorable
local centerTextHandler = {
    configPath = "unitFrames.player.powerBar.centerText",
}

ns.ApplyMixin(ns.Positionable, centerTextHandler)
ns.ApplyMixin(ns.Fontable, centerTextHandler)
ns.ApplyMixin(ns.Anchorable, centerTextHandler)

BUFPlayerPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.centerText = {
    anchorPoint = "CENTER",
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

local centerText = {
    type = "group",
    handler = centerTextHandler,
    name = ns.L["Center Text"],
    order = BUFPlayerPower.topGroupOrder.CENTER_TEXT,
    args = {}
}

ns.AddAnchorOptions(centerText.args, BUFPlayerPower.textOrder)
ns.AddPositioningOptions(centerText.args, BUFPlayerPower.textOrder)
ns.AddFontOptions(centerText.args, BUFPlayerPower.textOrder)

ns.options.args.unitFrames.args.player.args.powerBar.args.centerText = centerText

function centerTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function centerTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.powerBar.centerText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.powerBar.centerText.fontObject
        BUFPlayer.manaBar.ManaBarText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.powerBar.centerText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.powerBar.centerText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.powerBar.centerText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFPlayer.manaBar.ManaBarText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function centerTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.centerText.fontColor)
    BUFPlayer.manaBar.ManaBarText:SetTextColor(r, g, b, a)
end

function centerTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.powerBar.centerText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.centerText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.powerBar.centerText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.powerBar.centerText.fontShadowOffsetY
    if a == 0 then
        BUFPlayer.manaBar.ManaBarText:SetShadowOffset(0, 0)
    else
        BUFPlayer.manaBar.ManaBarText:SetShadowColor(r, g, b, a)
        BUFPlayer.manaBar.ManaBarText:SetShadowOffset(offsetX, offsetY)
    end
end

function centerTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.player.powerBar.centerText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.player.powerBar.centerText.xOffset
    local yOffset = ns.db.profile.unitFrames.player.powerBar.centerText.yOffset
    BUFPlayer.manaBar.ManaBarText:ClearAllPoints()
    BUFPlayer.manaBar.ManaBarText:SetPoint(anchorPoint, xOffset, yOffset)
end