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

function BUFPlayerLevel:SetXOffset(_, xOffset)
    ns.db.profile.unitFrames.player.level.xOffset = xOffset
    self:UpdatePositionAndSize()
end

function BUFPlayerLevel:GetXOffset()
    return ns.db.profile.unitFrames.player.level.xOffset
end

function BUFPlayerLevel:SetYOffset(_, yOffset)
    ns.db.profile.unitFrames.player.level.yOffset = yOffset
    self:UpdatePositionAndSize()
end

function BUFPlayerLevel:GetYOffset()
    return ns.db.profile.unitFrames.player.level.yOffset
end

function BUFPlayerLevel:SetUseFontObjects(_, useFontObjects)
    ns.db.profile.unitFrames.player.level.useFontObjects = useFontObjects
    self:SetFont()
    self:SetFontShadow()
end

function BUFPlayerLevel:GetUseFontObjects()
    return ns.db.profile.unitFrames.player.level.useFontObjects
end

function BUFPlayerLevel:SetFontObject(_, fontObject)
    ns.db.profile.unitFrames.player.level.fontObject = fontObject
    self:SetFont()
end

function BUFPlayerLevel:GetFontObject()
    return ns.db.profile.unitFrames.player.level.fontObject
end

function BUFPlayerLevel:SetFontColor(_, r, g, b, a)
    ns.db.profile.unitFrames.player.level.fontColor = { r, g, b, a }
    self:UpdateFontColor()
end

function BUFPlayerLevel:GetFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.level.fontColor)
    return r, g, b, a
end

function BUFPlayerLevel:SetFontFace(_, fontFace)
    ns.db.profile.unitFrames.player.level.fontFace = fontFace
    self:SetFont()
end

function BUFPlayerLevel:GetFontFace()
    return ns.db.profile.unitFrames.player.level.fontFace
end

function BUFPlayerLevel:SetFontSize(_, fontSize)
    ns.db.profile.unitFrames.player.level.fontSize = fontSize
    self:SetFont()
end

function BUFPlayerLevel:GetFontSize()
    return ns.db.profile.unitFrames.player.level.fontSize
end

function BUFPlayerLevel:SetFontFlag(info, key, value)
    ns.db.profile.unitFrames.player.level.fontFlags[key] = value
    self:SetFont()
end

function BUFPlayerLevel:GetFontFlag(info, key)
    return ns.db.profile.unitFrames.player.level.fontFlags[key]
end


function BUFPlayerLevel:SetShadowColor(_, r, g, b, a)
    ns.db.profile.unitFrames.player.level.fontShadowColor = { r, g, b, a }
    self:SetFontShadow()
end

function BUFPlayerLevel:GetShadowColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.level.fontShadowColor)
    return r, g, b, a
end

function BUFPlayerLevel:SetShadowOffsetX(_, offsetX)
    ns.db.profile.unitFrames.player.level.fontShadowOffsetX = offsetX
    self:SetFontShadow()
end

function BUFPlayerLevel:GetShadowOffsetX()
    return ns.db.profile.unitFrames.player.level.fontShadowOffsetX
end

function BUFPlayerLevel:SetShadowOffsetY(_, offsetY)
    ns.db.profile.unitFrames.player.level.fontShadowOffsetY = offsetY
    self:SetFontShadow()
end

function BUFPlayerLevel:GetShadowOffsetY()
    return ns.db.profile.unitFrames.player.level.fontShadowOffsetY
end

-- Disabled functions
function BUFPlayerLevel:IsCustomFontDisabled(info)
    return ns.db.profile.unitFrames.player.level.useFontObjects == false
end

function BUFPlayerLevel:IsFontObjectEnabled(info)
    return ns.db.profile.unitFrames.player.level.useFontObjects == true
end

function BUFPlayerLevel:RefreshConfig()
    self:UpdatePositionAndSize()
    self:SetFont()
    self:SetFontShadow()
end

function BUFPlayerLevel:UpdatePositionAndSize()
    local xOffset = ns.db.profile.unitFrames.player.level.xOffset
    local yOffset = ns.db.profile.unitFrames.player.level.yOffset
    PlayerLevelText:SetPoint("TOPRIGHT", xOffset, yOffset)
    -- PlayerLevelText:SetWidth(width)
    -- PlayerLevelText:SetHeight(height)
end

function BUFPlayerLevel:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.player.level.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.level.fontObject
        PlayerLevelText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.level.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.level.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.player.level.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        PlayerLevelText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function BUFPlayerLevel:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.level.fontColor)
    PlayerLevelText:SetTextColor(r, g, b, a)
end

function BUFPlayerLevel:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.level.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.level.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.level.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.level.fontShadowOffsetY
    if a == 0 then
        PlayerLevelText:SetShadowOffset(0, 0)
    else
        PlayerLevelText:SetShadowColor(r, g, b, a)
        PlayerLevelText:SetShadowOffset(offsetX, offsetY)
    end
end
