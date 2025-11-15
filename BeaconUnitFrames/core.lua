---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.addonVersion = "@project-version@"

---@class BUFAddon: AceAddon-3.0, AceConsole-3.0
local BUF = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0")
ns.BUF = BUF

ns.localeName = addonName .. "Locale"
ns.lsm = LibStub("LibSharedMedia-3.0")
ns.dbName = addonName .. "DB"
ns.dbDefaults = {
    profile = {
        -- Default settings go here
    },
}
ns.dbIcon = LibStub("LibDBIcon-1.0")
ns.PP = LibStub("LibPixelPerfect-1.0")

function BUF:OnInitialize()
    ---@class BUFDB: AceDBObject-3.0
    self.db = LibStub("AceDB-3.0"):New(ns.dbName, ns.dbDefaults, true)
end
