---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.RightText: BUFConfigHandler, Positionable, Fontable, Anchorable
local rightTextHandler = {
    configPath = "unitFrames.target.healthBar.rightText",
}


ns.ApplyMixin(ns.Positionable, rightTextHandler)
ns.ApplyMixin(ns.Fontable, rightTextHandler)
ns.ApplyMixin(ns.Anchorable, rightTextHandler)

BUFTargetHealth.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.rightText = {
    anchorPoint = "RIGHT",
    xOffset = -5,
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
    order = BUFTargetHealth.topGroupOrder.RIGHT_TEXT,
    args = {}
}

ns.AddAnchorOptions(rightText.args, BUFTargetHealth.textOrder)
ns.AddPositionableOptions(rightText.args, BUFTargetHealth.textOrder)
ns.AddFontOptions(rightText.args, BUFTargetHealth.textOrder)

rightText.args.relativeTo = nil
rightText.args.relativePoint = nil

ns.options.args.unitFrames.args.target.args.healthBar.args.rightText = rightText

function rightTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function rightTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.target.healthBar.rightText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.target.healthBar.rightText.fontObject
        BUFTarget.healthBarContainer.RightText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.target.healthBar.rightText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.target.healthBar.rightText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.target.healthBar.rightText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFTarget.healthBarContainer.RightText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function rightTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.rightText.fontColor)
    BUFTarget.healthBarContainer.RightText:SetTextColor(r, g, b, a)
end

function rightTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.target.healthBar.rightText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.rightText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.target.healthBar.rightText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.target.healthBar.rightText.fontShadowOffsetY
    if a == 0 then
        BUFTarget.healthBarContainer.RightText:SetShadowOffset(0, 0)
    else
        BUFTarget.healthBarContainer.RightText:SetShadowColor(r, g, b, a)
        BUFTarget.healthBarContainer.RightText:SetShadowOffset(offsetX, offsetY)
    end
end

function rightTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.target.healthBar.rightText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.target.healthBar.rightText.xOffset
    local yOffset = ns.db.profile.unitFrames.target.healthBar.rightText.yOffset
    local relativeTo = ns.BUFTarget.healthBar
    BUFTarget.healthBarContainer.RightText:ClearAllPoints()
    BUFTarget.healthBarContainer.RightText:SetPoint(anchorPoint, relativeTo, anchorPoint, xOffset, yOffset)
end