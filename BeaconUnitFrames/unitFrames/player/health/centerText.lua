---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.CenterText: BUFConfigHandler, Positionable, Fontable, Anchorable
local centerTextHandler = {
    configPath = "unitFrames.player.healthBar.centerText",
}


ns.ApplyMixin(ns.Positionable, centerTextHandler)
ns.ApplyMixin(ns.Fontable, centerTextHandler)
ns.ApplyMixin(ns.Anchorable, centerTextHandler)

BUFPlayerHealth.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar

ns.dbDefaults.profile.unitFrames.player.healthBar.centerText = {
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
    order = BUFPlayerHealth.topGroupOrder.CENTER_TEXT,
    args = {}
}

ns.AddAnchorOptions(centerText.args, BUFPlayerHealth.textOrder)
ns.AddPositionableOptions(centerText.args, BUFPlayerHealth.textOrder)
ns.AddFontOptions(centerText.args, BUFPlayerHealth.textOrder)

ns.options.args.unitFrames.args.player.args.healthBar.args.centerText = centerText

function centerTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function centerTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.healthBar.centerText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.healthBar.centerText.fontObject
        BUFPlayer.healthBarContainer.HealthBarText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.healthBar.centerText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.healthBar.centerText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.healthBar.centerText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFPlayer.healthBarContainer.HealthBarText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function centerTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.centerText.fontColor)
    BUFPlayer.healthBarContainer.HealthBarText:SetTextColor(r, g, b, a)
end

function centerTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.healthBar.centerText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.centerText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.healthBar.centerText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.healthBar.centerText.fontShadowOffsetY
    if a == 0 then
        BUFPlayer.healthBarContainer.HealthBarText:SetShadowOffset(0, 0)
    else
        BUFPlayer.healthBarContainer.HealthBarText:SetShadowColor(r, g, b, a)
        BUFPlayer.healthBarContainer.HealthBarText:SetShadowOffset(offsetX, offsetY)
    end
end

function centerTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.player.healthBar.centerText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.player.healthBar.centerText.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.centerText.yOffset
    BUFPlayer.healthBarContainer.HealthBarText:ClearAllPoints()
    BUFPlayer.healthBarContainer.HealthBarText:SetPoint(anchorPoint, xOffset, yOffset)
end