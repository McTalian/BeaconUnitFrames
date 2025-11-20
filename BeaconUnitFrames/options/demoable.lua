---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddDemoOptions(optionsTable, orderMap)
    optionsTable.enable = {
        type = "execute",
        name = ns.L["Demo"],
        desc = ns.L["DemoDesc"],
        width = "full",
        func = "ToggleDemoMode",
        order = orderMap.DEMO_MODE or 9999,
    }
end

---@class DemoableHandler: BUFConfigHandler
---@field ToggleDemoMode fun(self: DemoableHandler)

---@class Demoable: DemoableHandler
local Demoable = {}

ns.Demoable = Demoable