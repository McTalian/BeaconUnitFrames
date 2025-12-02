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

---@class MixinBase: BUFConfigHandler
local MixinBase = {}

--- Db accessor for mixins
--- @param key string
--- @param errorIfMissing? boolean
function MixinBase:DbGet(key, errorIfMissing)
	return getPath(ns.db.profile, self.configPath .. "." .. key, errorIfMissing)
end

--- Db mutator for mixins
--- @param key string
--- @param value any
function MixinBase:DbSet(key, value)
	setPath(ns.db.profile, self.configPath .. "." .. key, value)
end

ns.Mixin = Mixin
ns.MixinBase = MixinBase
