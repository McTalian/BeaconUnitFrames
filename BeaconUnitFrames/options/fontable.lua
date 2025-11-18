---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

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