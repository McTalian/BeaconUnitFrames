---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.LeftText: BUFConfigHandler, Positionable, Fontable, Anchorable
local leftTextHandler = {
    configPath = "unitFrames.player.healthBar.leftText",
}


ns.ApplyMixin(ns.Positionable, leftTextHandler)
ns.ApplyMixin(ns.Fontable, leftTextHandler)
ns.ApplyMixin(ns.Anchorable, leftTextHandler)

BUFPlayerHealth.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar

ns.dbDefaults.profile.unitFrames.player.healthBar.leftText = {
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
    order = BUFPlayerHealth.topGroupOrder.LEFT_TEXT,
    args = {}
}

ns.AddAnchorOptions(leftText.args, BUFPlayerHealth.textOrder)
ns.AddPositionableOptions(leftText.args, BUFPlayerHealth.textOrder)
ns.AddFontOptions(leftText.args, BUFPlayerHealth.textOrder)

ns.options.args.unitFrames.args.player.args.healthBar.args.leftText = leftText

function leftTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function leftTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.healthBar.leftText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.healthBar.leftText.fontObject
        BUFPlayer.healthBarContainer.LeftText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.healthBar.leftText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.healthBar.leftText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.healthBar.leftText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFPlayer.healthBarContainer.LeftText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function leftTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.leftText.fontColor)
    BUFPlayer.healthBarContainer.LeftText:SetTextColor(r, g, b, a)
end

function leftTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.healthBar.leftText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.leftText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.healthBar.leftText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.healthBar.leftText.fontShadowOffsetY
    if a == 0 then
        BUFPlayer.healthBarContainer.LeftText:SetShadowOffset(0, 0)
    else
        BUFPlayer.healthBarContainer.LeftText:SetShadowColor(r, g, b, a)
        BUFPlayer.healthBarContainer.LeftText:SetShadowOffset(offsetX, offsetY)
    end
end

function leftTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.player.healthBar.leftText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.player.healthBar.leftText.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.leftText.yOffset
    BUFPlayer.healthBarContainer.LeftText:ClearAllPoints()
    BUFPlayer.healthBarContainer.LeftText:SetPoint(anchorPoint, xOffset, yOffset)
end
