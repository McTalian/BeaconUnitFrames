---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.LeftText: BUFConfigHandler, Positionable, Fontable, Anchorable
local leftTextHandler = {
    configPath = "unitFrames.target.powerBar.leftText",
}

ns.ApplyMixin(ns.Positionable, leftTextHandler)
ns.ApplyMixin(ns.Fontable, leftTextHandler)
ns.ApplyMixin(ns.Anchorable, leftTextHandler)

BUFTargetPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.leftText = {
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
    order = BUFTargetPower.topGroupOrder.LEFT_TEXT,
    args = {}
}

ns.AddAnchorOptions(leftText.args, BUFTargetPower.textOrder)
ns.AddPositionableOptions(leftText.args, BUFTargetPower.textOrder)
ns.AddFontOptions(leftText.args, BUFTargetPower.textOrder)

ns.options.args.unitFrames.args.target.args.powerBar.args.leftText = leftText

function leftTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function leftTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.target.powerBar.leftText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.target.powerBar.leftText.fontObject
        BUFTarget.manaBar.LeftText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.target.powerBar.leftText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.target.powerBar.leftText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.target.powerBar.leftText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFTarget.manaBar.LeftText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function leftTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.leftText.fontColor)
    BUFTarget.manaBar.LeftText:SetTextColor(r, g, b, a)
end

function leftTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.target.powerBar.leftText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.leftText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.target.powerBar.leftText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.target.powerBar.leftText.fontShadowOffsetY
    if a == 0 then
        BUFTarget.manaBar.LeftText:SetShadowOffset(0, 0)
    else
        BUFTarget.manaBar.LeftText:SetShadowColor(r, g, b, a)
        BUFTarget.manaBar.LeftText:SetShadowOffset(offsetX, offsetY)
    end
end

function leftTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.target.powerBar.leftText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.target.powerBar.leftText.xOffset
    local yOffset = ns.db.profile.unitFrames.target.powerBar.leftText.yOffset
    BUFTarget.manaBar.LeftText:ClearAllPoints()
    BUFTarget.manaBar.LeftText:SetPoint(anchorPoint, xOffset, yOffset)
end