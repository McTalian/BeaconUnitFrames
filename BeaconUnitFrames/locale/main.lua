---@type string, table
local _, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFLocale
ns.L = LibStub("AceLocale-3.0"):GetLocale(ns.localeName)
