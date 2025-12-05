---@class BUFNamespace
local ns = select(2, ...)

-- Helper function to interpret a key part (convert to number if numeric)
local function interpretKey(key)
	local num = tonumber(key)
	return num ~= nil and num or key -- Return number if key is numeric, otherwise string
end

-- Helper function to get a nested table value by path
local function getPath(db, path, errorIfMissing)
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

-- Helper function to set a nested table value by path
local function setPath(db, path, value)
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

-- Helper function to clear a nested table value by path
local function clearPath(db, path)
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

---@class BUFDbBackedHandler
---@field configPath string
---@field dbKey string
local DbBackedHandler = {}

function DbBackedHandler:ensureDbKey()
	if not self.dbKey then
		self.dbKey = "profile"
	end
end

--- Db accessor
--- @param key string
--- @param errorIfMissing? boolean
function DbBackedHandler:DbGet(key, errorIfMissing)
	return getPath(ns.db[self.dbKey], self.configPath .. "." .. key, errorIfMissing)
end

--- Db mutator
--- @param key string
--- @param value any
function DbBackedHandler:DbSet(key, value)
	setPath(ns.db[self.dbKey], self.configPath .. "." .. key, value)
end

--- Db clearer
--- @param key string?
function DbBackedHandler:DbClear(key)
	if key == nil then
		clearPath(ns.db[self.dbKey], self.configPath)
		return
	end
	clearPath(ns.db[self.dbKey], self.configPath .. "." .. key)
end

---@type BUFDbBackedHandler
local ProfileDbBackedHandler = {
	dbKey = "profile",
}
Mixin(ProfileDbBackedHandler, DbBackedHandler)

---@type BUFDbBackedHandler
local GlobalDbBackedHandler = {
	dbKey = "global",
}
Mixin(GlobalDbBackedHandler, DbBackedHandler)

ns.ProfileDbBackedHandler = ProfileDbBackedHandler
ns.GlobalDbBackedHandler = GlobalDbBackedHandler
