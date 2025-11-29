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

---@class BUFUnitFrames
local UnitFrames = {}

UnitFrames.optionsOrder = {
    PLAYER = 1,
    TARGET = 2,
    PET = 3,
}

function UnitFrames:RefreshConfig()
    ns.BUFPlayer:RefreshConfig()
    ns.BUFTarget:RefreshConfig()
    ns.BUFPet:RefreshConfig()
end

ns.BUFUnitFrames = UnitFrames

