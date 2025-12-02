---@class BUFNamespace
local ns = select(2, ...)

---@class DbManager
local DbManager = {
	dbName = "BUFDB", -- Must match the TOC file
}

---@class BUFDbSchema: AceDB.Schema
ns.dbDefaults = {
	global = {
		lastVersionLoaded = "",
		minimap = {
			hide = true,
		},
		restoreCvars = {},
	},
	profile = {},
}

function DbManager:Initialize()
	---@class BUFDB: AceDBObject-3.0, BUFDbSchema
	ns.db = LibStub("AceDB-3.0"):New(self.dbName, ns.dbDefaults, true)
end

ns.DbManager = DbManager
