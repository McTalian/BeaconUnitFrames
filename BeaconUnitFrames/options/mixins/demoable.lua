---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add demo options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddDemoOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    optionsTable.enable = {
        type = "execute",
        name = ns.L["Demo"],
        desc = ns.L["DemoDesc"],
        width = "full",
        func = "ToggleDemoMode",
        order = orderMap.DEMO_MODE,
    }
end

---@class DemoableHandler: BUFConfigHandler
---@field ToggleDemoMode fun(self: DemoableHandler)

---@class Demoable: DemoableHandler
local Demoable = {}

ns.Demoable = Demoable