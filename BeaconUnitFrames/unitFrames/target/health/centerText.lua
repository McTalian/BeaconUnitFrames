---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.CenterText: BUFConfigHandler, Positionable, Fontable, Anchorable
local centerTextHandler = {
    configPath = "unitFrames.target.healthBar.centerText",
}


ns.ApplyMixin(ns.Positionable, centerTextHandler)
ns.ApplyMixin(ns.Fontable, centerTextHandler)
ns.ApplyMixin(ns.Anchorable, centerTextHandler)

BUFTargetHealth.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.centerText = {
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
    order = BUFTargetHealth.topGroupOrder.CENTER_TEXT,
    args = {}
}

ns.AddAnchorOptions(centerText.args, BUFTargetHealth.textOrder)
ns.AddPositionableOptions(centerText.args, BUFTargetHealth.textOrder)
ns.AddFontOptions(centerText.args, BUFTargetHealth.textOrder)

centerText.args.relativeTo = nil
centerText.args.relativePoint = nil

ns.options.args.unitFrames.args.target.args.healthBar.args.centerText = centerText

function centerTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function centerTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.target.healthBar.centerText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.target.healthBar.centerText.fontObject
        BUFTarget.healthBarContainer.HealthBarText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.target.healthBar.centerText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.target.healthBar.centerText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.target.healthBar.centerText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFTarget.healthBarContainer.HealthBarText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function centerTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.centerText.fontColor)
    BUFTarget.healthBarContainer.HealthBarText:SetTextColor(r, g, b, a)
end

function centerTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.target.healthBar.centerText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.centerText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.target.healthBar.centerText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.target.healthBar.centerText.fontShadowOffsetY
    if a == 0 then
        BUFTarget.healthBarContainer.HealthBarText:SetShadowOffset(0, 0)
    else
        BUFTarget.healthBarContainer.HealthBarText:SetShadowColor(r, g, b, a)
        BUFTarget.healthBarContainer.HealthBarText:SetShadowOffset(offsetX, offsetY)
    end
end

function centerTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.target.healthBar.centerText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.target.healthBar.centerText.xOffset
    local yOffset = ns.db.profile.unitFrames.target.healthBar.centerText.yOffset
    local relativeTo = ns.BUFTarget.healthBar
    BUFTarget.healthBarContainer.HealthBarText:ClearAllPoints()
    BUFTarget.healthBarContainer.HealthBarText:SetPoint(anchorPoint, relativeTo, anchorPoint, xOffset, yOffset)
end