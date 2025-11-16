---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.DbManager = {
    dbName = "BUFDB", -- Must match the TOC file
}

---@class BUFDbSchema: AceDB.Schema
ns.dbDefaults = {
    global = {
        lastVersionLoaded = "",
        minimap = {
            hide = true,
        }
    },
    profile = {},
}

function ns.DbManager:Initialize()
    ---@class BUFDB: AceDBObject-3.0, BUFDbSchema
    ns.db = LibStub("AceDB-3.0"):New(self.dbName, ns.dbDefaults, true)
end
