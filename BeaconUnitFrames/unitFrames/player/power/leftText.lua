---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.LeftText: BUFConfigHandler, Positionable, Fontable, Anchorable
local leftTextHandler = {
    configPath = "unitFrames.player.powerBar.leftText",
}

ns.ApplyMixin(ns.Positionable, leftTextHandler)
ns.ApplyMixin(ns.Fontable, leftTextHandler)
ns.ApplyMixin(ns.Anchorable, leftTextHandler)

BUFPlayerPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.leftText = {
    anchorPoint = "LEFT",
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

ns.AddAnchorOptions(leftText.args, BUFPlayerPower.textOrder)
ns.AddPositionableOptions(leftText.args, BUFPlayerPower.textOrder)
ns.AddFontOptions(leftText.args, BUFPlayerPower.textOrder)

ns.options.args.unitFrames.args.player.args.powerBar.args.leftText = leftText

function leftTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function leftTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.powerBar.leftText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.powerBar.leftText.fontObject
        BUFPlayer.manaBar.LeftText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.powerBar.leftText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.powerBar.leftText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.powerBar.leftText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFPlayer.manaBar.LeftText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function leftTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.leftText.fontColor)
    BUFPlayer.manaBar.LeftText:SetTextColor(r, g, b, a)
end

function leftTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.powerBar.leftText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.leftText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.powerBar.leftText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.powerBar.leftText.fontShadowOffsetY
    if a == 0 then
        BUFPlayer.manaBar.LeftText:SetShadowOffset(0, 0)
    else
        BUFPlayer.manaBar.LeftText:SetShadowColor(r, g, b, a)
        BUFPlayer.manaBar.LeftText:SetShadowOffset(offsetX, offsetY)
    end
end

function leftTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.player.powerBar.leftText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.player.powerBar.leftText.xOffset
    local yOffset = ns.db.profile.unitFrames.player.powerBar.leftText.yOffset
    BUFPlayer.manaBar.LeftText:ClearAllPoints()
    BUFPlayer.manaBar.LeftText:SetPoint(anchorPoint, xOffset, yOffset)
end