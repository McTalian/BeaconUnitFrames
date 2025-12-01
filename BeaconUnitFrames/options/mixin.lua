---@class BUFNamespace
local ns = select(2, ...)

---@class BUFConfigHandler
---@field configPath string
---@field optionsTable table
---@field dbDefaults table
---@field orderMap BUFOptionsOrder?
---@field RefreshConfig fun(self: BUFConfigHandler)

---@class BUFParentHandler
---@field optionsTable table
---@field optionsOrder BUFOptionsOrder
---@field RefreshConfig fun(self: BUFParentHandler)

ns.Mixin = Mixin
