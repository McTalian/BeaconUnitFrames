---@class BUFNamespace
local ns = select(2, ...)

---@class MixinBase: BUFConfigHandler
local MixinBase = {}

--- Db accessor for mixins
--- @param key string
--- @param errorIfMissing? boolean
function MixinBase:DbGet(key, errorIfMissing)
	return ns.DbUtils.getPath(ns.db.profile, self.configPath .. "." .. key, errorIfMissing)
end

--- Db mutator for mixins
--- @param key string
--- @param value any
function MixinBase:DbSet(key, value)
	ns.DbUtils.setPath(ns.db.profile, self.configPath .. "." .. key, value)
end

ns.Mixin = Mixin
ns.MixinBase = MixinBase
