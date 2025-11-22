---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.AddTextCustomizableOptions = function(optionsTable, orderMap)
    optionsTable.customText = {
        type = "input",
        name = ns.L["Custom Text"],
        desc = ns.L["CustomTextDesc"],
        set = "SetCustomText",
        get = "GetCustomText",
        order = orderMap.CUSTOM_TEXT or 1,
    }
end

---@class TextCustomizableHandler: BUFConfigHandler
---@field RefreshText fun(self: TextCustomizableHandler)

---@class TextCustomizable: TextCustomizableHandler
local TextCustomizable = {}

---Set the custom text
---@param info table AceConfig info table
---@param value string The custom text
function TextCustomizable:SetCustomText(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".customText", value)
    self:RefreshText()
end

---Get the custom text
---@param info table AceConfig info table
---@return string|nil The custom text
function TextCustomizable:GetCustomText(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".customText")
end

ns.TextCustomizable = TextCustomizable
