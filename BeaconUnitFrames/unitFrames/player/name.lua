---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Name: BUFConfigHandler, Positionable, Sizable, Fontable, TextCustomizable
local BUFPlayerName = {
    configPath = "unitFrames.player.name",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerName)
ns.ApplyMixin(ns.Sizable, BUFPlayerName)
ns.ApplyMixin(ns.TextCustomizable, BUFPlayerName)
ns.ApplyMixin(ns.Fontable, BUFPlayerName)

BUFPlayer.Name = BUFPlayerName

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Name
ns.dbDefaults.profile.unitFrames.player.name = {
    width = 96,
    height = 12,
    xOffset = 88,
    yOffset = -27,
    customText = nil,
    useFontObjects = true,
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

local nameOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    X_OFFSET = 3,
    Y_OFFSET = 4,
    CUSTOM_TEXT = 5,
    USE_FONT_OBJECTS = 6,
    FONT_OBJECT = 7,
    FONT_COLOR = 8,
    FONT_FACE = 9,
    FONT_SIZE = 10,
    FONT_FLAGS = 11,
    FONT_SHADOW_COLOR = 12,
    FONT_SHADOW_OFFSET_X = 13,
    FONT_SHADOW_OFFSET_Y = 14,
}

local playerName = {
    type = "group",
    handler = BUFPlayerName,
    name = CALENDAR_PLAYER_NAME,
    order = BUFPlayer.optionsOrder.NAME,
    args = {}
}

ns.AddSizingOptions(playerName.args, nameOrder)
ns.AddPositioningOptions(playerName.args, nameOrder)
ns.AddTextCustomizableOptions(playerName.args, nameOrder)
ns.AddFontOptions(playerName.args, nameOrder)

ns.options.args.unitFrames.args.player.args.playerName = playerName

function BUFPlayerName:RefreshConfig()
    self:SetPosition()
    self:SetSize()
    self:RefreshText()
    self:SetFont()
    self:SetFontShadow()
end

function BUFPlayerName:SetSize()
    local width = ns.db.profile.unitFrames.player.name.width
    local height = ns.db.profile.unitFrames.player.name.height
    PlayerName:SetWidth(width)
    PlayerName:SetHeight(height)
end

function BUFPlayerName:SetPosition()
    local xOffset = ns.db.profile.unitFrames.player.name.xOffset
    local yOffset = ns.db.profile.unitFrames.player.name.yOffset
    PlayerName:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerName:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.name.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.name.fontObject
        PlayerName:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.name.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.name.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.name.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        PlayerName:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function BUFPlayerName:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.name.fontColor)
    PlayerName:SetTextColor(r, g, b, a)
end

function BUFPlayerName:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.name.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.name.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.name.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.name.fontShadowOffsetY
    if a == 0 then
        PlayerName:SetShadowOffset(0, 0)
    else
        PlayerName:SetShadowColor(r, g, b, a)
        PlayerName:SetShadowOffset(offsetX, offsetY)
    end
end

function BUFPlayerName:RefreshText()
    local customText = ns.db.profile.unitFrames.player.name.customText
    if customText and customText ~= "" then
        PlayerName:SetText(customText)
    else
        PlayerName:SetText(UnitName("player"))
    end
end
