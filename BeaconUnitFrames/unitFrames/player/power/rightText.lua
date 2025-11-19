---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.RightText: BUFConfigHandler, Positionable, Fontable, Anchorable
local rightTextHandler = {
    configPath = "unitFrames.player.powerBar.rightText",
}

ns.ApplyMixin(ns.Positionable, rightTextHandler)
ns.ApplyMixin(ns.Fontable, rightTextHandler)
ns.ApplyMixin(ns.Anchorable, rightTextHandler)

BUFPlayerPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.rightText = {
    anchorPoint = "RIGHT",
    xOffset = -2,
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

local rightText = {
    type = "group",
    handler = rightTextHandler,
    name = ns.L["Right Text"],
    order = BUFPlayerPower.topGroupOrder.RIGHT_TEXT,
    args = {}
}

ns.AddAnchorOptions(rightText.args, BUFPlayerPower.textOrder)
ns.AddPositioningOptions(rightText.args, BUFPlayerPower.textOrder)
ns.AddFontOptions(rightText.args, BUFPlayerPower.textOrder)

ns.options.args.unitFrames.args.player.args.powerBar.args.rightText = rightText

function rightTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function rightTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.powerBar.rightText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.powerBar.rightText.fontObject
        BUFPlayer.manaBar.RightText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.powerBar.rightText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.powerBar.rightText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.powerBar.rightText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFPlayer.manaBar.RightText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function rightTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.rightText.fontColor)
    BUFPlayer.manaBar.RightText:SetTextColor(r, g, b, a)
end

function rightTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.powerBar.rightText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.rightText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.powerBar.rightText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.powerBar.rightText.fontShadowOffsetY
    if a == 0 then
        BUFPlayer.manaBar.RightText:SetShadowOffset(0, 0)
    else
        BUFPlayer.manaBar.RightText:SetShadowColor(r, g, b, a)
        BUFPlayer.manaBar.RightText:SetShadowOffset(offsetX, offsetY)
    end
end

function rightTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.player.powerBar.rightText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.player.powerBar.rightText.xOffset
    local yOffset = ns.db.profile.unitFrames.player.powerBar.rightText.yOffset
    BUFPlayer.manaBar.RightText:ClearAllPoints()
    BUFPlayer.manaBar.RightText:SetPoint(anchorPoint, xOffset, yOffset)
end