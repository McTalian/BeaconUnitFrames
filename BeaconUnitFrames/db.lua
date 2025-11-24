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
        },
		restoreCvars = {}
    },
    profile = {},
}

function ns.DbManager:Initialize()
    ---@class BUFDB: AceDBObject-3.0, BUFDbSchema
    ns.db = LibStub("AceDB-3.0"):New(self.dbName, ns.dbDefaults, true)
end

---@class DbUtils
local DbUtils = {}

-- Helper function to interpret a key part (convert to number if numeric)
local function interpretKey(key)
	local num = tonumber(key)
	return num ~= nil and num or key -- Return number if key is numeric, otherwise string
end

-- Helper function to get or set a nested table value by path
function DbUtils.getPath(db, path, errorIfMissing)
	local current = db
	for part in path:gmatch("[^.]+") do
		current = current[interpretKey(part)]
		if current == nil then
			if errorIfMissing then
				error("Path '" .. path .. "' does not exist in the database.")
			end
			return nil
		end
	end
	return current
end

function DbUtils.setPath(db, path, value)
	local parts = {}
	for part in path:gmatch("[^.]+") do
		table.insert(parts, part)
	end

	local lastKey = table.remove(parts)
	local current = db

	for _, part in ipairs(parts) do
		local key = interpretKey(part)
		if current[key] == nil then
			current[key] = {}
		end
		current = current[key]
	end

	current[interpretKey(lastKey)] = value
end

function DbUtils.clearPath(db, path)
	local parts = {}
	for part in path:gmatch("[^.]+") do
		table.insert(parts, part)
	end

	local lastKey = table.remove(parts)
	local current = db

	for _, part in ipairs(parts) do
		current = current[interpretKey(part)]
		if not current then
			return
		end
	end

	current[interpretKey(lastKey)] = nil
end

ns.DbUtils = DbUtils
