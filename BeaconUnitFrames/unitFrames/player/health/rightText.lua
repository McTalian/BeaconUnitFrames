---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.RightText: BUFConfigHandler, Positionable, Fontable, Anchorable
local rightTextHandler = {
    configPath = "unitFrames.player.healthBar.rightText",
}


ns.ApplyMixin(ns.Positionable, rightTextHandler)
ns.ApplyMixin(ns.Fontable, rightTextHandler)
ns.ApplyMixin(ns.Anchorable, rightTextHandler)

BUFPlayerHealth.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar

ns.dbDefaults.profile.unitFrames.player.healthBar.rightText = {
    anchorPoint = "RIGHT",
    xOffset = -2,
    yOffset = 0,
    useFontObjects = true,
    fontObject = "TextStatusBarText",
    fontColor = { 1, 1, 1, 1 },
    fontFace = "Friz Quadrata TT",
    fontSize = 10,
    fontFlags = {
        [ns.FontFlags.NONE] = true,
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
    order = BUFPlayerHealth.topGroupOrder.RIGHT_TEXT,
    args = {}
}

ns.AddAnchorOptions(rightText.args, BUFPlayerHealth.textOrder)
ns.AddPositioningOptions(rightText.args, BUFPlayerHealth.textOrder)
ns.AddFontOptions(rightText.args, BUFPlayerHealth.textOrder)

ns.options.args.unitFrames.args.player.args.healthBar.args.rightText = rightText

function rightTextHandler:RefreshConfig()
    self:SetFont()
    self:SetFontShadow()
    self:SetPosition()
end

function rightTextHandler:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.healthBar.rightText.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.healthBar.rightText.fontObject
        BUFPlayer.healthBarContainer.RightText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.healthBar.rightText.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.healthBar.rightText.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.healthBar.rightText.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        BUFPlayer.healthBarContainer.RightText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function rightTextHandler:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.rightText.fontColor)
    BUFPlayer.healthBarContainer.RightText:SetTextColor(r, g, b, a)
end

function rightTextHandler:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.healthBar.rightText.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.rightText.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.healthBar.rightText.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.healthBar.rightText.fontShadowOffsetY
    if a == 0 then
        BUFPlayer.healthBarContainer.RightText:SetShadowOffset(0, 0)
    else
        BUFPlayer.healthBarContainer.RightText:SetShadowColor(r, g, b, a)
        BUFPlayer.healthBarContainer.RightText:SetShadowOffset(offsetX, offsetY)
    end
end

function rightTextHandler:SetPosition()
    local anchorPoint = ns.db.profile.unitFrames.player.healthBar.rightText.anchorPoint
    local xOffset = ns.db.profile.unitFrames.player.healthBar.rightText.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.rightText.yOffset
    BUFPlayer.healthBarContainer.RightText:ClearAllPoints()
    BUFPlayer.healthBarContainer.RightText:SetPoint(anchorPoint, xOffset, yOffset)
end