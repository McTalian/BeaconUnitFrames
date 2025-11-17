---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Level
local BUFPlayerLevel = {}

BUFPlayer.Level = BUFPlayerLevel

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Level
ns.dbDefaults.profile.unitFrames.player.level = {
    xOffset = -24.5,
    yOffset = -28,
    useFontObjects = true,
    fontObject = "GameFontNormalSmall",
    fontColor = { NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.a },
    fontFace = "Friz Quadrata TT",
    fontSize = 12,
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

local levelOrder = {
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

local level = {
    type = "group",
    handler = BUFPlayerLevel,
    name = LEVEL,
    order = BUFPlayer.optionsOrder.LEVEL,
    inline = true,
    args = {}
}

ns.AddPositioningOptions(level.args, levelOrder)
ns.AddFontOptions(level.args, levelOrder)

ns.options.args.unitFrames.args.player.args.level = level

function BUFPlayerLevel:RefreshConfig()
    self:UpdatePositionAndSize()
    self:SetFont()
    self:SetFontShadow()
end

function BUFPlayerLevel:UpdatePositionAndSize()
    local width = ns.db.profile.unitFrames.player.name.width
    local height = ns.db.profile.unitFrames.player.name.height
    local xOffset = ns.db.profile.unitFrames.player.name.xOffset
    local yOffset = ns.db.profile.unitFrames.player.name.yOffset
    PlayerLevelText:SetPoint("TOPLEFT", xOffset, yOffset)
    PlayerLevelText:SetWidth(width)
    PlayerLevelText:SetHeight(height)
end

function BUFPlayerLevel:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.name.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.name.fontObject
        PlayerLevelText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.name.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.name.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.name.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        PlayerLevelText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function BUFPlayerLevel:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.name.fontColor)
    PlayerLevelText:SetTextColor(r, g, b, a)
end

function BUFPlayerLevel:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.name.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local shadowColor = ns.db.profile.unitFrames.player.name.fontShadowColor
    local offsetX = ns.db.profile.unitFrames.player.name.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.name.fontShadowOffsetY
    if shadowColor[4] == 0 then
        PlayerLevelText:SetShadowOffset(0, 0)
    else
        PlayerLevelText:SetShadowColor(unpack(shadowColor))
        PlayerLevelText:SetShadowOffset(offsetX, offsetY)
    end
end
