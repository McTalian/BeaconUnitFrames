---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddPowerColorOptions(optionsTable, orderMap)
    optionsTable.usePowerColor = {
        type = "toggle",
        name = ns.L["Use Power Color"],
        desc = ns.L["UsePowerColorDesc"],
        set = "SetUsePowerColor",
        get = "GetUsePowerColor",
        order = orderMap.POWER_COLOR or 13,
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
---@param info table AceConfig info table
---@return boolean|nil Whether to use power color
function PowerColorable:GetUsePowerColor(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".usePowerColor")
end

ns.PowerColorable = PowerColorable
