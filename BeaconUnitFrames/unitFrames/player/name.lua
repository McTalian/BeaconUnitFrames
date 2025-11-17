---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Name
ns.dbDefaults.profile.unitFrames.player.name = {
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
		[ns.FontFlags.NONE] = true,
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

ns.options.args.unitFrames.args.player.args.playerName = {
    type = "group",
    name = CALENDAR_PLAYER_NAME,
    order = BUFPlayer.optionsOrder.NAME,
    inline = true,
    args = {
        width = {
            type = "range",
            name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_WIDTH,
            min = 20,
            max = 300,
            step = 1,
            bigStep = 5,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.width = value
                ns.BUFPlayer:UpdateNamePositionAndSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.width
            end,
            order = nameOrder.WIDTH,
        },
        height = {
            type = "range",
            name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_HEIGHT,
            min = 8,
            max = 100,
            step = 1,
            bigStep = 2,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.height = value
                ns.BUFPlayer:UpdateNamePositionAndSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.height
            end,
            order = nameOrder.HEIGHT,
        },
        xOffset = {
            type = "range",
            name = ns.L["X Offset"],
            min = -200,
            max = 400,
            step = 1,
            bigStep = 5,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.xOffset = value
                ns.BUFPlayer:UpdateNamePositionAndSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.xOffset
            end,
            order = nameOrder.X_OFFSET,
        },
        yOffset = {
            type = "range",
            name = ns.L["Y Offset"],
            min = -200,
            max = 200,
            step = 1,
            bigStep = 5,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.yOffset = value
                ns.BUFPlayer:UpdateNamePositionAndSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.yOffset
            end,
            order = nameOrder.Y_OFFSET,
        },
        useFontObjects = {
            type = "toggle",
            name = ns.L["Use Font Objects"],
            desc = ns.L["UseFontObjectsDesc"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.useFontObjects = value
                ns.BUFPlayer:SetNameFont()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.useFontObjects
            end,
            order = nameOrder.USE_FONT_OBJECTS,
        },
        fontObject = {
            type = "select",
            name = ns.L["Font Object"],
            desc = ns.L["FontObjectDesc"],
            values = ns.FontObjectOptions,
            disabled = function()
                return ns.db.profile.unitFrames.player.name.useFontObjects == false
            end,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.fontObject = value
                ns.BUFPlayer:SetNameFont()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.fontObject
            end,
            order = nameOrder.FONT_OBJECT,
        },
        fontColor = {
            type = "color",
            name = ns.L["Font Color"],
            hasAlpha = true,
            set = function(info, r, g, b, a)
                ns.db.profile.unitFrames.player.name.fontColor = { r, g, b, a }
                ns.BUFPlayer:SetNameFontColor()
            end,
            get = function(info)
                local r, g, b, a = unpack(ns.db.profile.unitFrames.player.name.fontColor)
                return r, g, b, a
            end,
            order = nameOrder.FONT_COLOR,
        },
        fontFace = {
            type = "select",
            name = ns.L["Font Face"],
            dialogControl = "LSM30_Font",
            values = function()
                return ns.lsm:HashTable(ns.lsm.MediaType.FONT)
            end,
            disabled = function()
                return ns.db.profile.unitFrames.player.name.useFontObjects == true
            end,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.fontFace = value
                ns.BUFPlayer:SetNameFont()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.fontFace
            end,
            order = nameOrder.FONT_FACE,
        },
        fontSize = {
            type = "range",
            name = FONT_SIZE,
            min = 4,
            softMin = 8,
            softMax = 72,
            max = 144,
            step = 1,
            bigStep = 2,
            disabled = function()
                return ns.db.profile.unitFrames.player.name.useFontObjects == true
            end,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.fontSize = value
                ns.BUFPlayer:SetNameFont()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.fontSize
            end,
            order = nameOrder.FONT_SIZE,
        },
        fontFlags = {
            type = "multiselect",
            name = ns.L["Font Flags"],
            values = ns.FontFlagsOptions,
            disabled = function()
                return ns.db.profile.unitFrames.player.name.useFontObjects == true
            end,
            set = function(info, key, value)
                ns.db.profile.unitFrames.player.name.fontFlags[key] = value
                ns.BUFPlayer:SetNameFont()
            end,
            get = function(info, key)
                return ns.db.profile.unitFrames.player.name.fontFlags[key]
            end,
            order = nameOrder.FONT_FLAGS,
        },
        shadowColor = {
            type = "color",
            name = ns.L["Font Shadow Color"],
            hasAlpha = true,
            disabled = function()
                return ns.db.profile.unitFrames.player.name.useFontObjects == true
            end,
            set = function(info, r, g, b, a)
                ns.db.profile.unitFrames.player.name.fontShadowColor = { r, g, b, a }
                BUFPlayer:SetNameFontShadow()
            end,
            get = function(info)
                local r, g, b, a = unpack(ns.db.profile.unitFrames.player.name.fontShadowColor)
                return r, g, b, a
            end,
            order = nameOrder.FONT_SHADOW_COLOR,
        },
        shadowOffsetX = {
            type = "range",
            name = ns.L["Font Shadow Offset X"],
            min = -10,
            max = 10,
            step = 1,
            bigStep = 1,
            disabled = function()
                return ns.db.profile.unitFrames.player.name.useFontObjects == true
            end,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.fontShadowOffsetX = value
                BUFPlayer:SetNameFontShadow()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.fontShadowOffsetX
            end,
            order = nameOrder.FONT_SHADOW_OFFSET_X,
        },
        shadowOffsetY = {
            type = "range",
            name = ns.L["Font Shadow Offset Y"],
            min = -10,
            max = 10,
            step = 1,
            bigStep = 1,
            disabled = function()
                return ns.db.profile.unitFrames.player.name.useFontObjects == true
            end,
            set = function(info, value)
                ns.db.profile.unitFrames.player.name.fontShadowOffsetY = value
                BUFPlayer:SetNameFontShadow()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.name.fontShadowOffsetY
            end,
            order = nameOrder.FONT_SHADOW_OFFSET_Y,
        },
    }
}

function BUFPlayer:RefreshNameConfig()
    self:UpdateNamePositionAndSize()
    self:SetNameFont()
    self:SetNameFontShadow()
end

function BUFPlayer:UpdateNamePositionAndSize()
    local width = ns.db.profile.unitFrames.player.name.width
    local height = ns.db.profile.unitFrames.player.name.height
    local xOffset = ns.db.profile.unitFrames.player.name.xOffset
    local yOffset = ns.db.profile.unitFrames.player.name.yOffset
    PlayerName:SetPoint("TOPLEFT", xOffset, yOffset)
    PlayerName:SetWidth(width)
    PlayerName:SetHeight(height)
end

function BUFPlayer:SetNameFont()
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
        print("Setting name font to:", fontPath, fontSize, fontFlags)
        PlayerName:SetFont(fontPath, fontSize, fontFlags)
    end
    BUFPlayer:SetNameFontColor()
end

function BUFPlayer:SetNameFontColor()
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.name.fontColor)
    PlayerName:SetTextColor(r, g, b, a)
end

function BUFPlayer:SetNameFontShadow()
    local useFontObjects = ns.db.profile.unitFrames.player.name.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local shadowColor = ns.db.profile.unitFrames.player.name.fontShadowColor
    local offsetX = ns.db.profile.unitFrames.player.name.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.name.fontShadowOffsetY
    if shadowColor[4] == 0 then
        PlayerName:SetShadowOffset(0, 0)
    else
        PlayerName:SetShadowColor(unpack(shadowColor))
        PlayerName:SetShadowOffset(offsetX, offsetY)
    end
end
