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
	OUTLINE = "OUTLINE",
	THICKOUTLINE = "THICKOUTLINE",
	MONOCHROME = "MONOCHROME",
}

ns.FontFlagsOptions = {
    [ns.FontFlags.OUTLINE] = SELF_HIGHLIGHT_OUTLINE,
    [ns.FontFlags.THICKOUTLINE] = ns.L["Thick Outline"],
    [ns.FontFlags.MONOCHROME] = ns.L["Monochrome"],
}

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

--- Add font options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddFontOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.fontSettings = optionsTable.fontSettings or {
        type = "header",
        name = ns.L["Font Settings"],
        order = orderMap.FONT_SETTINGS_HEADER,
    }

    optionsTable.useFontObjects = {
        type = "toggle",
        name = ns.L["Use Font Objects"],
        desc = ns.L["UseFontObjectsDesc"],
        set = "SetUseFontObjects",
        get = "GetUseFontObjects",
        order = orderMap.USE_FONT_OBJECTS,
    }
    
    optionsTable.fontObject = {
        type = "select",
        name = ns.L["Font Object"],
        desc = ns.L["FontObjectDesc"],
        values = ns.FontObjectOptions,
        disabled = "IsCustomFontDisabled",
        set = "SetFontObject",
        get = "GetFontObject",
        order = orderMap.FONT_OBJECT,
    }
    
    optionsTable.fontColor = {
        type = "color",
        name = ns.L["Font Color"],
        hasAlpha = true,
        set = "SetFontColor",
        get = "GetFontColor",
        order = orderMap.FONT_COLOR,
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
        order = orderMap.FONT_FACE,
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
        order = orderMap.FONT_SIZE,
    }
    
    optionsTable.fontFlags = {
        type = "multiselect",
        name = ns.L["Font Flags"],
        values = ns.FontFlagsOptions,
        disabled = "IsFontObjectEnabled",
        set = "SetFontFlag",
        get = "GetFontFlag",
        order = orderMap.FONT_FLAGS,
    }
    
    optionsTable.shadowColor = {
        type = "color",
        name = ns.L["Font Shadow Color"],
        hasAlpha = true,
        disabled = "IsFontObjectEnabled",
        set = "SetShadowColor",
        get = "GetShadowColor",
        order = orderMap.FONT_SHADOW_COLOR,
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
        order = orderMap.FONT_SHADOW_OFFSET_X,
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
        order = orderMap.FONT_SHADOW_OFFSET_Y,
    }
end

---@class FontableHandler: BUFConfigHandler
---@field SetFont fun(self: FontableHandler)
---@field UpdateFontColor fun(self: FontableHandler)
---@field SetFontShadow fun(self: FontableHandler)

---@class Fontable: FontableHandler
local Fontable = {}

function Fontable:SetUseFontObjects(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useFontObjects", value)
    self:SetFont()
end

function Fontable:GetUseFontObjects(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useFontObjects")
end

function Fontable:SetFontObject(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".fontObject", value)
    self:SetFont()
end

function Fontable:GetFontObject(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontObject")
end

function Fontable:SetFontColor(info, r, g, b, a)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".fontColor", { r, g, b, a })
    self:UpdateFontColor()
end

function Fontable:GetFontColor(info)
    local color = ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontColor")
    if color then
        return unpack(color)
    end
    return 1, 1, 1, 1 -- default white
end

function Fontable:SetFontFace(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".fontFace", value)
    self:SetFont()
end

function Fontable:GetFontFace(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontFace")
end

function Fontable:SetFontSize(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".fontSize", value)
    self:SetFont()
end

function Fontable:GetFontSize(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontSize")
end

function Fontable:SetFontFlag(info, key, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".fontFlags." .. key, value)
    self:SetFont()
end

function Fontable:GetFontFlag(info, key)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontFlags." .. key)
end

function Fontable:SetShadowColor(info, r, g, b, a)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".fontShadowColor", { r, g, b, a })
    self:SetFontShadow()
end

function Fontable:GetShadowColor(info)
    local color = ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontShadowColor")
    if color then
        return unpack(color)
    end
    return 0, 0, 0, 1 -- default black shadow
end

function Fontable:SetShadowOffsetX(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".fontShadowOffsetX", value)
    self:SetFontShadow()
end

function Fontable:GetShadowOffsetX(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontShadowOffsetX")
end

function Fontable:SetShadowOffsetY(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".fontShadowOffsetY", value)
    self:SetFontShadow()
end

function Fontable:GetShadowOffsetY(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontShadowOffsetY")
end

-- Disabled state functions
function Fontable:IsCustomFontDisabled(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useFontObjects") == false
end

function Fontable:IsFontObjectEnabled(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useFontObjects") == true
end

ns.Fontable = Fontable