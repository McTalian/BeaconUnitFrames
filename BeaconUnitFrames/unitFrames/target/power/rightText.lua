---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.RightText: BUFConfigHandler, Positionable, Fontable, Anchorable
local rightTextHandler = {
    configPath = "unitFrames.target.powerBar.rightText",
}

ns.ApplyMixin(ns.Positionable, rightTextHandler)
ns.ApplyMixin(ns.Fontable, rightTextHandler)
ns.ApplyMixin(ns.Anchorable, rightTextHandler)

BUFTargetPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.rightText = {
    anchorPoint = "RIGHT",
    xOffset = -13,
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
    order = BUFTargetPower.topGroupOrder.RIGHT_TEXT,
    args = {}
}

ns.AddAnchorOptions(rightText.args, BUFTargetPower.textOrder)
ns.AddPositionableOptions(rightText.args, BUFTargetPower.textOrder)
ns.AddFontOptions(rightText.args, BUFTargetPower.textOrder)

ns.options.args.unitFrames.args.target.args.powerBar.args.rightText = rightText

function rightTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function rightTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.target.powerBar.rightText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.target.powerBar.rightText.fontObject
        BUFTarget.manaBar.RightText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.target.powerBar.rightText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.target.powerBar.rightText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.target.powerBar.rightText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFTarget.manaBar.RightText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function rightTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.rightText.fontColor)
    BUFTarget.manaBar.RightText:SetTextColor(r, g, b, a)
end

function rightTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.target.powerBar.rightText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.rightText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.target.powerBar.rightText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.target.powerBar.rightText.fontShadowOffsetY
    if a == 0 then
        BUFTarget.manaBar.RightText:SetShadowOffset(0, 0)
    else
        BUFTarget.manaBar.RightText:SetShadowColor(r, g, b, a)
        BUFTarget.manaBar.RightText:SetShadowOffset(offsetX, offsetY)
    end
end

function rightTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.target.powerBar.rightText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.target.powerBar.rightText.xOffset
    local yOffset = ns.db.profile.unitFrames.target.powerBar.rightText.yOffset
    BUFTarget.manaBar.RightText:ClearAllPoints()
    BUFTarget.manaBar.RightText:SetPoint(anchorPoint, xOffset, yOffset)
end