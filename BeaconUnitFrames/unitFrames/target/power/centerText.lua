---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.CenterText: BUFConfigHandler, Positionable, Fontable, Anchorable
local centerTextHandler = {
    configPath = "unitFrames.target.powerBar.centerText",
}

ns.ApplyMixin(ns.Positionable, centerTextHandler)
ns.ApplyMixin(ns.Fontable, centerTextHandler)
ns.ApplyMixin(ns.Anchorable, centerTextHandler)

BUFTargetPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.centerText = {
    anchorPoint = "CENTER",
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

ns.AddAnchorOptions(centerText.args, BUFTargetPower.textOrder)
ns.AddPositioningOptions(centerText.args, BUFTargetPower.textOrder)
ns.AddFontOptions(centerText.args, BUFTargetPower.textOrder)

ns.options.args.unitFrames.args.target.args.powerBar.args.centerText = centerText

function centerTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function centerTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.target.powerBar.centerText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.target.powerBar.centerText.fontObject
        BUFTarget.manaBar.ManaBarText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.target.powerBar.centerText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.target.powerBar.centerText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.target.powerBar.centerText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFTarget.manaBar.ManaBarText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function centerTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.centerText.fontColor)
    BUFTarget.manaBar.ManaBarText:SetTextColor(r, g, b, a)
end

function centerTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.target.powerBar.centerText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.centerText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.target.powerBar.centerText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.target.powerBar.centerText.fontShadowOffsetY
    if a == 0 then
        BUFTarget.manaBar.ManaBarText:SetShadowOffset(0, 0)
    else
        BUFTarget.manaBar.ManaBarText:SetShadowColor(r, g, b, a)
        BUFTarget.manaBar.ManaBarText:SetShadowOffset(offsetX, offsetY)
    end
end

function centerTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.target.powerBar.centerText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.target.powerBar.centerText.xOffset
    local yOffset = ns.db.profile.unitFrames.target.powerBar.centerText.yOffset
    BUFTarget.manaBar.ManaBarText:ClearAllPoints()
    BUFTarget.manaBar.ManaBarText:SetPoint(anchorPoint, xOffset, yOffset)
end