---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFDbSchema: AceDB.Schema
ns.dbDefaults = ns.dbDefaults

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = {}

ns.options.args.unitFrames = {
    type = "group",
    name = UNITFRAME_LABEL,
    childGroups = "tree",
    order = 1,
    args = {},
}
