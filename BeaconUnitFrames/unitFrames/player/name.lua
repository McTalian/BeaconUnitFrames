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

ns.options.args.unitFrames.args.player.args.playerName = {
    type = "group",
    name = CALENDAR_PLAYER_NAME,
    order = BUFPlayer.optionsOrder.NAME,
    inline = true,
    args = {
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
            order = 1,
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
            order = 2,
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
            order = 3,
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
            order = 4,
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
            order = 5,
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
            order = 6,
        },
    }
}

function BUFPlayer:RefreshNameConfig()
    self:SetNameFont()
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
