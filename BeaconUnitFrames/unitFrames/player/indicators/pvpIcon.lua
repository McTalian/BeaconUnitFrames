---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.PvPIcon: BUFConfigHandler, Positionable, AtlasScalable, Demoable
local BUFPlayerPvPIcon = {
    configPath = "unitFrames.player.pvpIcon",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerPvPIcon)
ns.ApplyMixin(ns.AtlasScalable, BUFPlayerPvPIcon)
ns.ApplyMixin(ns.Demoable, BUFPlayerPvPIcon)

---@class BUFPlayer.PvPIcon.PvPTimerText: Positionable, Fontable, Demoable
local PvPTimerText = {
    configPath = "unitFrames.player.pvpIcon.pvpTimerText",
}

ns.ApplyMixin(ns.Positionable, PvPTimerText)
ns.ApplyMixin(ns.Fontable, PvPTimerText)
ns.ApplyMixin(ns.Demoable, PvPTimerText)

BUFPlayerPvPIcon.PvPTimerText = PvPTimerText

BUFPlayerIndicators.PvPIcon = BUFPlayerPvPIcon

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.PvPIcon
ns.dbDefaults.profile.unitFrames.player.pvpIcon = {
    xOffset = 25,
    yOffset = -50,
    useAtlasSize = true,
    scale = 1.0,
}

local pvpIconOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    USE_ATLAS_SIZE = 3,
    SCALE = 4,
    PVP_TIMER_TEXT = 5,
}

local pvpIcon = {
    type = "group",
    handler = BUFPlayerPvPIcon,
    name = ns.L["PvP Icon"],
    order = BUFPlayerIndicators.optionsOrder.PVP_ICON,
    args = {},
}

ns.AddPositionableOptions(pvpIcon.args, pvpIconOrder)
ns.AddAtlasScalableOptions(pvpIcon.args, pvpIconOrder)
ns.AddDemoOptions(pvpIcon.args, pvpIconOrder)

---@class BUFDbSchema.UF.Player.PvPIcon.PvPTimerText
ns.dbDefaults.profile.unitFrames.player.pvpIcon.pvpTimerText = {
    xOffset = 0,
    yOffset = 2,
    useFontObject = true,
    fontObject = "GameFontNormalSmall",
    fontColor = { NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.a },
    fontFace = "Friz Quadrata TT",
    fontSize = 12,
    fontFlags = {
      [ns.FontFlags.OUTLINE] = false,
      [ns.FontFlags.THICKOUTLINE] = false,
      [ns.FontFlags.MONOCHROME] = false,
    },
    fontShadowColor = { 0, 0, 0, 1 },
    fontShadowOffsetX = 1,
    fontShadowOffsetY = -1,
}

local pvpTimerTextOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    USE_FONT_OBJECTS = 3,
    FONT_OBJECT = 4,
    FONT_COLOR = 5,
    FONT_FACE = 6,
    FONT_SIZE = 7,
    FONT_FLAGS = 8,
    FONT_SHADOW_COLOR = 9,
    FONT_SHADOW_OFFSET_X = 10,
    FONT_SHADOW_OFFSET_Y = 11,
}

local pvpTimerText = {
    type = "group",
    handler = PvPTimerText,
    name = ns.L["PvP Timer Text"],
    order = pvpIconOrder.PVP_TIMER_TEXT,
    args = {},
}

pvpIcon.args.pvpTimerText = pvpTimerText

ns.AddFontOptions(pvpTimerText.args, pvpTimerTextOrder)
ns.AddDemoOptions(pvpTimerText.args, pvpTimerTextOrder)

ns.options.args.unitFrames.args.player.args.pvpIcon = pvpIcon

function BUFPlayerPvPIcon:ToggleDemoMode()
    local pvpIcon = BUFPlayer.contentContextual.PVPIcon
    local factionGroup, factionName = UnitFactionGroup("player");
    if factionGroup ~= "Horde" and factionGroup ~= "Alliance" then
        factionGroup = "FFA"
    end
    local iconSuffix = string.lower(factionGroup) .. "icon"
    if self.demoMode then
        self.demoMode = false
        pvpIcon:Hide()
    else
        self.demoMode = true
        pvpIcon:SetAtlas("ui-hud-unitframe-player-pvp-" .. iconSuffix, true)
        pvpIcon:Show()
    end
end

function PvPTimerText:ToggleDemoMode()
    local pvpTimerText = BUFPlayer.contentContextual.PvpTimerText
    if self.demoMode then
        self.demoMode = false
        pvpTimerText:Hide()
    else
        self.demoMode = true
        pvpTimerText:Show()
        pvpTimerText:SetFormattedText(SecondsToTimeAbbrev(120));
    end
end

function BUFPlayerPvPIcon:RefreshConfig()
  self:SetPosition()
  self:SetScaleFactor()
  self.PvPTimerText:RefreshConfig()
end

function BUFPlayerPvPIcon:SetPosition()
    local pvpIcon = BUFPlayer.contentContextual.PVPIcon
    local db = ns.db.profile.unitFrames.player.pvpIcon
    pvpIcon:ClearAllPoints()
    pvpIcon:SetPoint("TOP", BUFPlayer.contentContextual, "TOPLEFT", db.xOffset, db.yOffset)
end

function BUFPlayerPvPIcon:SetScaleFactor()
    local pvpIcon = BUFPlayer.contentContextual.PVPIcon
    local scale = ns.db.profile.unitFrames.player.pvpIcon.scale
    pvpIcon:SetScale(scale)
end

function PvPTimerText:RefreshConfig()
  self:SetPosition()
  self:SetFont()
  self:SetFontShadow()
end

function PvPTimerText:SetPosition()
    local pvpTimerText = BUFPlayer.contentContextual.PvpTimerText
    local db = ns.db.profile.unitFrames.player.pvpIcon.pvpTimerText
    pvpTimerText:SetPoint("TOP", BUFPlayer.contentContextual.PVPIcon, "BOTTOM", db.xOffset, db.yOffset)
end

function PvPTimerText:SetFont()
    local pTTDB = ns.db.profile.unitFrames.player.pvpIcon.pvpTimerText
    local pvpTimerText = BUFPlayer.contentContextual.PvpTimerText
    local useFontObjects = pTTDB.useFontObject

    if useFontObjects then
        local fontObject = pTTDB.fontObject
        pvpTimerText:SetFontObject(_G[fontObject])
    else
        local fontFace = pTTDB.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = pTTDB.fontSize
        local fontFlagsTable = pTTDB.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        pvpTimerText:SetFont(fontPath, fontSize, fontFlags)
    end

    self:UpdateFontColor()
end

function PvPTimerText:UpdateFontColor()
    local pTTDB = ns.db.profile.unitFrames.player.pvpIcon.pvpTimerText
    local r, g, b, a = unpack(pTTDB.fontColor)
    local pvpTimerText = BUFPlayer.contentContextual.PvpTimerText
    pvpTimerText:SetTextColor(r, g, b, a)
end

function PvPTimerText:SetFontShadow()
    local pTTDB = ns.db.profile.unitFrames.player.pvpIcon.pvpTimerText
    local useFontObjects = pTTDB.useFontObject
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end

    local pvpTimerText = BUFPlayer.contentContextual.PvpTimerText
    local r, g, b, a = unpack(pTTDB.fontShadowColor)
    local xOffset = pTTDB.fontShadowOffsetX
    local yOffset = pTTDB.fontShadowOffsetY

    if a == 0 then
        pvpTimerText:SetShadowOffset(0, 0)
    else
        pvpTimerText:SetShadowColor(r, g, b, a)
        pvpTimerText:SetShadowOffset(xOffset, yOffset)
    end
end
