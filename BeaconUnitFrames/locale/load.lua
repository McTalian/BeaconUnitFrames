---@class BUFNamespace
local ns = select(2, ...)

---@class BUFLocale
ns.L = LibStub("AceLocale-3.0"):GetLocale(ns.localeName)

