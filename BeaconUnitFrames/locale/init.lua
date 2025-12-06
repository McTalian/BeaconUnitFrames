---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

ns.localeName = addonName .. "Locale"
