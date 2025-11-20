---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.LeftText: BUFConfigHandler, Positionable, Fontable, Anchorable
local leftTextHandler = {
    configPath = "unitFrames.target.healthBar.leftText",
}


ns.ApplyMixin(ns.Positionable, leftTextHandler)
ns.ApplyMixin(ns.Fontable, leftTextHandler)
ns.ApplyMixin(ns.Anchorable, leftTextHandler)

BUFTargetHealth.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.leftText = {
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
    order = BUFTargetHealth.topGroupOrder.LEFT_TEXT,
    args = {}
}

ns.AddAnchorOptions(leftText.args, BUFTargetHealth.textOrder)
ns.AddPositioningOptions(leftText.args, BUFTargetHealth.textOrder)
ns.AddFontOptions(leftText.args, BUFTargetHealth.textOrder)

leftText.args.relativeTo = nil
leftText.args.relativePoint = nil

ns.options.args.unitFrames.args.target.args.healthBar.args.leftText = leftText

function leftTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function leftTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.target.healthBar.leftText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.target.healthBar.leftText.fontObject
        BUFTarget.healthBarContainer.LeftText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.target.healthBar.leftText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.target.healthBar.leftText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.target.healthBar.leftText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFTarget.healthBarContainer.LeftText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function leftTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.leftText.fontColor)
    BUFTarget.healthBarContainer.LeftText:SetTextColor(r, g, b, a)
end

function leftTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.target.healthBar.leftText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.leftText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.target.healthBar.leftText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.target.healthBar.leftText.fontShadowOffsetY
    if a == 0 then
        BUFTarget.healthBarContainer.LeftText:SetShadowOffset(0, 0)
    else
        BUFTarget.healthBarContainer.LeftText:SetShadowColor(r, g, b, a)
        BUFTarget.healthBarContainer.LeftText:SetShadowOffset(offsetX, offsetY)
    end
end

function leftTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.target.healthBar.leftText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.target.healthBar.leftText.xOffset
    local yOffset = ns.db.profile.unitFrames.target.healthBar.leftText.yOffset
    local relativeTo = ns.BUFTarget.healthBar
    BUFTarget.healthBarContainer.LeftText:ClearAllPoints()
    BUFTarget.healthBarContainer.LeftText:SetPoint(anchorPoint, relativeTo, anchorPoint, xOffset, yOffset)
end
