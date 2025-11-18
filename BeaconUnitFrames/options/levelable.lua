---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddFrameLevelOption(optionsTable, orderMap)
    optionsTable.frameLevel = {
        type = "range",
        name = ns.L["Frame Level"],
        min = 0,
        max = 10000,
        step = 1,
        bigStep = 10,
        set = "SetFrameLevel",
        get = "GetFrameLevel",
        order = orderMap.FRAME_LEVEL or 5,
    }
end

---@class LevelableHandler: BUFConfigHandler
---@field SetLevel fun(self: LevelableHandler)

---@class Levelable: LevelableHandler
local Levelable = {}

function Levelable:SetFrameLevel(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".frameLevel", value)
    self:SetLevel()
end

function Levelable:GetFrameLevel(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".frameLevel")
end

ns.Levelable = Levelable