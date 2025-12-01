---@class BUFNamespace
local ns = select(2, ...)

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
---@field _SetFont fun(self: FontableHandler, fontable: FontString) -- Should be FontInstance
---@field _UpdateFontColor fun(self: FontableHandler, fontable: FontString)
---@field _SetFontShadow fun(self: FontableHandler, fontable: FontString)

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

function Fontable:GetFontFlags(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".fontFlags")
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

function Fontable:_SetFont(fontable)
    local useFontObjects = self:GetUseFontObjects()
    if useFontObjects then
        local fontObjectName = self:GetFontObject()
        if not fontObjectName or fontObjectName == "" or _G[fontObjectName] == nil then
            error("Font object '" .. fontObjectName .. "' does not exist.")
        end
        fontable:SetFontObject(_G[fontObjectName])
    else
        local fontFace = self:GetFontFace() or "NONE"
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face '" .. fontFace .. "' not found. Using: ", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = self:GetFontSize() or 10
        local fontFlagsTable = self:GetFontFlags() or {}
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        fontable:SetFont(fontPath, fontSize, fontFlags)
    end

    self:UpdateFontColor()
end

function Fontable:_UpdateFontColor(fontable)
    local fontColor = { self:GetFontColor() } or { 1, 1, 1, 1 }
    local r, g, b, a = unpack(fontColor)
    fontable:SetTextColor(r, g, b, a)
end

function Fontable:_SetFontShadow(fontable)
    local useFontObjects = self:GetUseFontObjects()
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local fontShadowColor = { self:GetShadowColor() } or { 0, 0, 0, 1 }
    local r, g, b, a = unpack(fontShadowColor)
    local offsetX = self:GetShadowOffsetX() or 0
    local offsetY = self:GetShadowOffsetY() or 0
    if a == 0 then
        fontable:SetShadowOffset(0, 0)
    else
        fontable:SetShadowColor(r, g, b, a)
        fontable:SetShadowOffset(offsetX, offsetY)
    end
end

ns.Fontable = Fontable