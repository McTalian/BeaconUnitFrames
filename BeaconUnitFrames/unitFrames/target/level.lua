---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Level: BUFConfigHandler, Positionable, Fontable
local BUFTargetLevel = {
    configPath = "unitFrames.target.level",
}

ns.ApplyMixin(ns.Positionable, BUFTargetLevel)
ns.ApplyMixin(ns.Fontable, BUFTargetLevel)

BUFTarget.Level = BUFTargetLevel

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Level
ns.dbDefaults.profile.unitFrames.target.level = {
    xOffset = -24.5,
    yOffset = -28,
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
    handler = BUFTargetLevel,
    name = LEVEL,
    order = BUFTarget.optionsOrder.LEVEL,
    args = {}
}

ns.AddPositionableOptions(level.args, levelOrder)
ns.AddFontOptions(level.args, levelOrder)

ns.options.args.unitFrames.args.target.args.level = level

function BUFTargetLevel:RefreshConfig()
    self:SetPosition()
    self:SetFont()
    self:SetFontShadow()
end

function BUFTargetLevel:SetPosition()
    local xOffset = ns.db.profile.unitFrames.target.level.xOffset
    local yOffset = ns.db.profile.unitFrames.target.level.yOffset
    ns.BUFTarget.contentMain.LevelText:SetPoint("TOPRIGHT", xOffset, yOffset)
end

function BUFTargetLevel:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.target.level.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.target.level.fontObject
        ns.BUFTarget.contentMain.LevelText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.target.level.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.target.level.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.target.level.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        ns.BUFTarget.contentMain.LevelText:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function BUFTargetLevel:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.level.fontColor)
    ns.BUFTarget.contentMain.LevelText:SetTextColor(r, g, b, a)
end

function BUFTargetLevel:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.target.level.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.level.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.target.level.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.target.level.fontShadowOffsetY
    if a == 0 then
        ns.BUFTarget.contentMain.LevelText:SetShadowOffset(0, 0)
    else
        ns.BUFTarget.contentMain.LevelText:SetShadowColor(r, g, b, a)
        ns.BUFTarget.contentMain.LevelText:SetShadowOffset(offsetX, offsetY)
    end
end
