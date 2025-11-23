---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Name: BUFConfigHandler, Positionable, Sizable, Fontable
local BUFTargetName = {
    configPath = "unitFrames.target.name",
}

ns.ApplyMixin(ns.Positionable, BUFTargetName)
ns.ApplyMixin(ns.Sizable, BUFTargetName)
ns.ApplyMixin(ns.Fontable, BUFTargetName)

BUFTarget.Name = BUFTargetName

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Name
ns.dbDefaults.profile.unitFrames.target.name = {
    width = 96,
    height = 12,
    xOffset = 88,
    yOffset = -27,
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
    USE_FONT_OBJECTS = 5,
    FONT_OBJECT = 6,
    FONT_COLOR = 7,
    FONT_FACE = 8,
    FONT_SIZE = 9,
    FONT_FLAGS = 10,
    FONT_SHADOW_COLOR = 11,
    FONT_SHADOW_OFFSET_X = 12,
    FONT_SHADOW_OFFSET_Y = 13,
}

local targetName = {
    type = "group",
    handler = BUFTargetName,
    name = ns.L["Target Name"],
    order = BUFTarget.optionsOrder.NAME,
    args = {}
}

ns.AddSizableOptions(targetName.args, nameOrder)
ns.AddPositionableOptions(targetName.args, nameOrder)
ns.AddFontOptions(targetName.args, nameOrder)

ns.options.args.unitFrames.args.target.args.targetName = targetName

function BUFTargetName:RefreshConfig()
    self:SetPosition()
    self:SetSize()
    self:SetFont()
    self:SetFontShadow()
end

function BUFTargetName:SetSize()
    local width = ns.db.profile.unitFrames.target.name.width
    local height = ns.db.profile.unitFrames.target.name.height
    ns.BUFTarget.contentMain.Name:SetWidth(width)
    ns.BUFTarget.contentMain.Name:SetHeight(height)
end

function BUFTargetName:SetPosition()
    local xOffset = ns.db.profile.unitFrames.target.name.xOffset
    local yOffset = ns.db.profile.unitFrames.target.name.yOffset
    ns.BUFTarget.contentMain.Name:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFTargetName:SetFont()
    local useFontObjects = ns.db.profile.unitFrames.target.name.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.target.name.fontObject
        ns.BUFTarget.contentMain.Name:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.target.name.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face not found, using default:", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.target.name.fontSize
        local fontFlagsTable = ns.db.profile.unitFrames.target.name.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        ns.BUFTarget.contentMain.Name:SetFont(fontPath, fontSize, fontFlags)
    end
    self:UpdateFontColor()
end

function BUFTargetName:UpdateFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.name.fontColor)
    ns.BUFTarget.contentMain.Name:SetTextColor(r, g, b, a)
end

function BUFTargetName:SetFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.target.name.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.target.name.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.target.name.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.target.name.fontShadowOffsetY
    if a == 0 then
        ns.BUFTarget.contentMain.Name:SetShadowOffset(0, 0)
    else
        ns.BUFTarget.contentMain.Name:SetShadowColor(r, g, b, a)
        ns.BUFTarget.contentMain.Name:SetShadowOffset(offsetX, offsetY)
    end
end
