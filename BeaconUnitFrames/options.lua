---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---Check if a string starts with another string
---@param str string
---@param start string
---@return boolean
local function startswith(str, start)
	return string.sub(str, 1, #start) == start
end

ns.FontFlags = {
	NONE = "",
	OUTLINE = "OUTLINE",
	THICKOUTLINE = "THICKOUTLINE",
	MONOCHROME = "MONOCHROME",
}

ns.FontFlagsOptions = {
    [ns.FontFlags.NONE] = NONE,
    [ns.FontFlags.OUTLINE] = SELF_HIGHLIGHT_OUTLINE,
    [ns.FontFlags.THICKOUTLINE] = ns.L["Thick Outline"],
    [ns.FontFlags.MONOCHROME] = ns.L["Monochrome"],
}

function ns:TableToCommaSeparatedString(tbl)
	local result = {}
	for key, value in pairs(tbl) do
		if value then
			table.insert(result, key)
		end
	end
	return table.concat(result, ", ")
end

function ns.FontFlagsToString(fontFlagsTable)
    return ns:TableToCommaSeparatedString(fontFlagsTable)
end

function ns.FontObjectOptions()
    local fonts = _G.GetFonts()
    local allFonts = {}
    for k, v in pairs(fonts) do
        if type(v) == "string" then
            if startswith(v, "table") then
            -- Skip
            else
                allFonts[v] = v
            end
        end
    end
    return allFonts
end

ns.OptionsManager = {}

function ns.OptionsManager:Initialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, ns.options)
end

-- Helper function to add positioning options (xOffset, yOffset)
function ns.AddPositioningOptions(optionsTable, orderMap)
    optionsTable.xOffset = {
        type = "range",
        name = ns.L["X Offset"],
        min = -500,
        softMin = -200,
        softMax = 200,
        max = 500,
        step = 1,
        bigStep = 5,
        set = "SetXOffset",
        get = "GetXOffset",
        order = orderMap.X_OFFSET or 100,
    }
    
    optionsTable.yOffset = {
        type = "range",
        name = ns.L["Y Offset"],
        min = -500,
        softMin = -200,
        softMax = 200,
        max = 500,
        step = 1,
        bigStep = 5,
        set = "SetYOffset",
        get = "GetYOffset",
        order = orderMap.Y_OFFSET or 101,
    }
end

-- Helper function to add sizing options (width, height)
function ns.AddSizingOptions(optionsTable, orderMap)
    optionsTable.width = {
        type = "range",
        name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_WIDTH,
        min = 1,
        softMin = 50,
        softMax = 800,
        max = 1000000000,
        step = 1,
        bigStep = 10,
        set = "SetWidth",
        get = "GetWidth",
        order = orderMap.WIDTH or 1,
    }
    
    optionsTable.height = {
        type = "range",
        name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_HEIGHT,
        min = 1,
        softMin = 5,
        softMax = 600,
        max = 1000000000,
        step = 1,
        bigStep = 5,
        set = "SetHeight",
        get = "GetHeight",
        order = orderMap.HEIGHT or 2,
    }
end

-- Helper function to add font options
function ns.AddFontOptions(optionsTable, orderMap)
    optionsTable.useFontObjects = {
        type = "toggle",
        name = ns.L["Use Font Objects"],
        desc = ns.L["UseFontObjectsDesc"],
        set = "SetUseFontObjects",
        get = "GetUseFontObjects",
        order = orderMap.USE_FONT_OBJECTS or 10,
    }
    
    optionsTable.fontObject = {
        type = "select",
        name = ns.L["Font Object"],
        desc = ns.L["FontObjectDesc"],
        values = ns.FontObjectOptions,
        disabled = "IsCustomFontDisabled",
        set = "SetFontObject",
        get = "GetFontObject",
        order = orderMap.FONT_OBJECT or 11,
    }
    
    optionsTable.fontColor = {
        type = "color",
        name = ns.L["Font Color"],
        hasAlpha = true,
        set = "SetFontColor",
        get = "GetFontColor",
        order = orderMap.FONT_COLOR or 12,
    }
    
    optionsTable.fontFace = {
        type = "select",
        name = ns.L["Font Face"],
        dialogControl = "LSM30_Font",
        values = function()
            return ns.lsm:HashTable(ns.lsm.MediaType.FONT)
        end,
        disabled = "IsFontObjectEnabled",
        set = "SetFontFace",
        get = "GetFontFace",
        order = orderMap.FONT_FACE or 13,
    }
    
    optionsTable.fontSize = {
        type = "range",
        name = FONT_SIZE,
        min = 4,
        softMin = 8,
        softMax = 72,
        max = 144,
        step = 1,
        bigStep = 2,
        disabled = "IsFontObjectEnabled",
        set = "SetFontSize",
        get = "GetFontSize",
        order = orderMap.FONT_SIZE or 14,
    }
    
    optionsTable.fontFlags = {
        type = "multiselect",
        name = ns.L["Font Flags"],
        values = ns.FontFlagsOptions,
        disabled = "IsFontObjectEnabled",
        set = "SetFontFlag",
        get = "GetFontFlag",
        order = orderMap.FONT_FLAGS or 15,
    }
    
    optionsTable.shadowColor = {
        type = "color",
        name = ns.L["Font Shadow Color"],
        hasAlpha = true,
        disabled = "IsFontObjectEnabled",
        set = "SetShadowColor",
        get = "GetShadowColor",
        order = orderMap.FONT_SHADOW_COLOR or 16,
    }
    
    optionsTable.shadowOffsetX = {
        type = "range",
        name = ns.L["Font Shadow Offset X"],
        min = -10,
        max = 10,
        step = 1,
        bigStep = 1,
        disabled = "IsFontObjectEnabled",
        set = "SetShadowOffsetX",
        get = "GetShadowOffsetX",
        order = orderMap.FONT_SHADOW_OFFSET_X or 17,
    }
    
    optionsTable.shadowOffsetY = {
        type = "range",
        name = ns.L["Font Shadow Offset Y"],
        min = -10,
        max = 10,
        step = 1,
        bigStep = 1,
        disabled = "IsFontObjectEnabled",
        set = "SetShadowOffsetY",
        get = "GetShadowOffsetY",
        order = orderMap.FONT_SHADOW_OFFSET_Y or 18,
    }
end

-- Helper function to add status bar foreground options
function ns.AddStatusBarForegroundOptions(optionsTable, orderMap)
    optionsTable.useStatusBarTexture = {
        type = "toggle",
        name = ns.L["Use Status Bar Texture"],
        desc = ns.L["UseStatusBarTextureDesc"],
        set = "SetUseStatusBarTexture",
        get = "GetUseStatusBarTexture",
        order = orderMap.USE_STATUS_BAR_TEXTURE or 20,
    }
    
    optionsTable.statusBarTexture = {
        type = "select",
        name = ns.L["Status Bar Texture"],
        dialogControl = "LSM30_Statusbar",
        values = function()
            return ns.lsm:HashTable(ns.lsm.MediaType.STATUSBAR)
        end,
        disabled = "IsStatusBarTextureDisabled",
        set = "SetStatusBarTexture",
        get = "GetStatusBarTexture",
        order = orderMap.STATUS_BAR_TEXTURE or 21,
    }
    
    optionsTable.useCustomColor = {
        type = "toggle",
        name = ns.L["Use Custom Color"],
        desc = ns.L["UseCustomColorDesc"],
        set = "SetUseCustomColor",
        get = "GetUseCustomColor",
        order = orderMap.USE_CUSTOM_COLOR or 22,
    }
    
    optionsTable.customColor = {
        type = "color",
        name = ns.L["Custom Color"],
        hasAlpha = true,
        disabled = "IsCustomColorDisabled",
        set = "SetCustomColor",
        get = "GetCustomColor",
        order = orderMap.CUSTOM_COLOR or 23,
    }
    
    optionsTable.useClassColor = {
        type = "toggle",
        name = ns.L["Use Class Color"],
        desc = ns.L["UseClassColorDesc"],
        set = "SetUseClassColor",
        get = "GetUseClassColor",
        order = orderMap.USE_CLASS_COLOR or 24,
    }
end

-- Helper function to add background texture options
function ns.AddBackgroundTextureOptions(optionsTable, orderMap)
    optionsTable.useBackgroundTexture = {
        type = "toggle",
        name = ns.L["Use Background Texture"],
        desc = ns.L["UseBackgroundTextureDesc"],
        set = "SetUseBackgroundTexture",
        get = "GetUseBackgroundTexture",
        order = orderMap.USE_BACKGROUND_TEXTURE or 30,
    }
    
    optionsTable.backgroundTexture = {
        type = "select",
        name = ns.L["Background Texture"],
        dialogControl = "LSM30_Background",
        values = function()
            return ns.lsm:HashTable(ns.lsm.MediaType.BACKGROUND)
        end,
        disabled = "IsBackgroundTextureDisabled",
        set = "SetBackgroundTexture",
        get = "GetBackgroundTexture",
        order = orderMap.BACKGROUND_TEXTURE or 31,
    }
end

-- Helper function to add frame level option
function ns.AddFrameLevelOption(optionsTable, orderMap)
    optionsTable.frameLevel = {
        type = "range",
        name = ns.L["Frame Level"],
        min = 0,
        max = 10000,
        step = 1,
        bigStep = 10,
        set = "SetFrameLevel",
        get = "GetFrameLevel",
        order = orderMap.FRAME_LEVEL or 5,
    }
end

---@class BUFOptions: AceConfig.OptionsTable
ns.options = {
    name = addonName,
    type = "group",
    args = {},
}
