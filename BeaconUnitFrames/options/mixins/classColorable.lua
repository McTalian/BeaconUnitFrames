---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add class color options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddClassColorOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.coloring = optionsTable.coloring or {
        type = "header",
        name = ns.L["Coloring"],
        order = orderMap.COLORING_HEADER,
    }

    optionsTable.useClassColor = {
        type = "toggle",
        name = ns.L["Use Class Color"],
        desc = ns.L["UseClassColorDesc"],
        set = "SetUseClassColor",
        get = "GetUseClassColor",
        order = orderMap.CLASS_COLOR,
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
---@param info? table AceConfig info table
---@return boolean|nil Whether to use class color
function ClassColorable:GetUseClassColor(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useClassColor")
end

ns.ClassColorable = ClassColorable
