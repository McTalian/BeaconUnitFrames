---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFConfigHandler
---@field configPath string
---@field optionsTable table
---@field RefreshConfig fun(self: BUFConfigHandler)

function ns.ApplyMixin(source, target)
    for k, v in pairs(source) do
        target[k] = v
    end
end
