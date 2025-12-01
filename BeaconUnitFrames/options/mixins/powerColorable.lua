---@class BUFNamespace
local ns = select(2, ...)

--- Add power color options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddPowerColorOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    optionsTable.coloring = optionsTable.coloring or {
        type = "header",
        name = ns.L["Coloring"],
        order = orderMap.COLORING_HEADER,
    }

    optionsTable.usePowerColor = {
        type = "toggle",
        name = ns.L["Use Power Color"],
        desc = ns.L["UsePowerColorDesc"],
        set = "SetUsePowerColor",
        get = "GetUsePowerColor",
        order = orderMap.POWER_COLOR,
    }
end

---@class PowerColorable: ColorableHandler
local PowerColorable = {}


---Set whether to use power color
---@param info table AceConfig info table
---@param value boolean Whether to use power color
function PowerColorable:SetUsePowerColor(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".usePowerColor", value)
    self:RefreshColor()
end

---Get whether to use power color
---@param info? table AceConfig info table
---@return boolean|nil Whether to use power color
function PowerColorable:GetUsePowerColor(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".usePowerColor")
end

ns.PowerColorable = PowerColorable
