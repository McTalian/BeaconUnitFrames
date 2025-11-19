---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddColorOptions(optionsTable, orderMap)
    optionsTable.useCustomColor = {
        type = "toggle",
        name = ns.L["Use Custom Color"],
        desc = ns.L["UseCustomColorDesc"],
        set = "SetUseCustomColor",
        get = "GetUseCustomColor",
        order = orderMap.USE_CUSTOM_COLOR or 10,
    }
    
    optionsTable.customColor = {
        type = "color",
        name = ns.L["Custom Color"],
        hasAlpha = true,
        disabled = "IsCustomColorDisabled",
        set = "SetCustomColor",
        get = "GetCustomColor",
        order = orderMap.CUSTOM_COLOR or 11,
    }
end

---@class ColorableHandler: BUFConfigHandler
---@field RefreshColor fun(self: ColorableHandler)

---@class Colorable: ColorableHandler
local Colorable = {}

---Set whether to use a custom color
---@param info table AceConfig info table
---@param value boolean Whether to use custom color
function Colorable:SetUseCustomColor(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useCustomColor", value)
    self:RefreshColor()
end

---Get whether to use a custom color
---@param info table AceConfig info table
---@return boolean|nil Whether to use custom color
function Colorable:GetUseCustomColor(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useCustomColor")
end

---Set the custom color
---@param info table AceConfig info table
---@param r number Red component (0-1)
---@param g number Green component (0-1) 
---@param b number Blue component (0-1)
---@param a number Alpha component (0-1)
function Colorable:SetCustomColor(info, r, g, b, a)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".customColor", { r, g, b, a })
    self:RefreshColor()
end

---Get the custom color
---@param info table AceConfig info table
---@return number r Red component
---@return number g Green component
---@return number b Blue component 
---@return number a Alpha component
function Colorable:GetCustomColor(info)
    local color = ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".customColor")
    if color then
        return unpack(color)
    end
    return 1, 1, 1, 1 -- default white
end

---Check if custom color selection is disabled
---@param info table AceConfig info table
---@return boolean Whether custom color selection is disabled
function Colorable:IsCustomColorDisabled(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useCustomColor") == false
end

ns.Colorable = Colorable