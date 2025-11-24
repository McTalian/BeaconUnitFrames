---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add positionable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddPositionableOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.positioning = optionsTable.positioning or {
        type = "header",
        name = ns.L["Positioning"],
        order = orderMap.POSITIONING_HEADER,
    }

    optionsTable.xOffset = {
        type = "range",
        name = ns.L["X Offset"],
        min = -2000,
        softMin = -1000,
        softMax = 1000,
        max = 2000,
        step = 1,
        bigStep = 5,
        set = "SetXOffset",
        get = "GetXOffset",
        order = orderMap.X_OFFSET,
    }
    
    optionsTable.yOffset = {
        type = "range",
        name = ns.L["Y Offset"],
        min = -2000,
        softMin = -1000,
        softMax = 1000,
        max = 2000,
        step = 1,
        bigStep = 5,
        set = "SetYOffset",
        get = "GetYOffset",
        order = orderMap.Y_OFFSET,
    }
end

---@class PositionableHandler: BUFConfigHandler
---@field SetPosition fun(self: PositionableHandler)

---@class Positionable: PositionableHandler
local Positionable = {}

function Positionable:SetXOffset(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".xOffset", value)
    self:SetPosition()
end

function Positionable:GetXOffset(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".xOffset")
end

function Positionable:SetYOffset(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".yOffset", value)
    self:SetPosition()
end

function Positionable:GetYOffset(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".yOffset")
end

ns.Positionable = Positionable
