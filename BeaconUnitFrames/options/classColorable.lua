---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddClassColorOptions(optionsTable, orderMap)
    optionsTable.useClassColor = {
        type = "toggle",
        name = ns.L["Use Class Color"],
        desc = ns.L["UseClassColorDesc"],
        set = "SetUseClassColor",
        get = "GetUseClassColor",
        order = orderMap.CLASS_COLOR or 12,
    }
end

---@class ClassColorable: ColorableHandler
local ClassColorable = {}

---Set whether to use class color
---@param info table AceConfig info table
---@param value boolean Whether to use class color
function ClassColorable:SetUseClassColor(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useClassColor", value)
    self:RefreshColor()
end

---Get whether to use class color
---@param info table AceConfig info table
---@return boolean|nil Whether to use class color
function ClassColorable:GetUseClassColor(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useClassColor")
end

ns.ClassColorable = ClassColorable
