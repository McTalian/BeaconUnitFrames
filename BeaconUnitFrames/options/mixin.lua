---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFConfigHandler
---@field configPath string
---@field optionsTable table
---@field orderMap BUFOptionsOrder?
---@field RefreshConfig fun(self: BUFConfigHandler)

ns.Mixin = Mixin
