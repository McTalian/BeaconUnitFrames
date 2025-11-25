---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

local anchorPointOptions = {
    TOPLEFT = ns.L["TOPLEFT"],
    TOP = ns.L["TOP"],
    TOPRIGHT = ns.L["TOPRIGHT"],
    LEFT = ns.L["LEFT"],
    CENTER = ns.L["CENTER"],
    RIGHT = ns.L["RIGHT"],
    BOTTOMLEFT = ns.L["BOTTOMLEFT"],
    BOTTOM = ns.L["BOTTOM"],
    BOTTOMRIGHT = ns.L["BOTTOMRIGHT"],
}

local anchorPointSort = {
    "TOPLEFT",
    "TOP",
    "TOPRIGHT",
    "LEFT",
    "CENTER",
    "RIGHT",
    "BOTTOMLEFT",
    "BOTTOM",
    "BOTTOMRIGHT",
}

local anchorRelativeToOptions = {
    ["UIParent"] = ns.L["UIParent"],
    ["TargetFrame"] = ns.L["TargetFrame"],
    ["PlayerFrame"] = HUD_EDIT_MODE_PLAYER_FRAME_LABEL,
}
anchorRelativeToOptions[ns.DEFAULT] = ns.L["Default Relative Frame"]

local anchorRelativeToSort = {
    "UIParent",
    "TargetFrame",
    "PlayerFrame",
}
table.insert(anchorRelativeToSort, 1, ns.DEFAULT)

local anchorRelativePointOptions = {
    TOPLEFT = ns.L["TOPLEFT"],
    TOP = ns.L["TOP"],
    TOPRIGHT = ns.L["TOPRIGHT"],
    LEFT = ns.L["LEFT"],
    CENTER = ns.L["CENTER"],
    RIGHT = ns.L["RIGHT"],
    BOTTOMLEFT = ns.L["BOTTOMLEFT"],
    BOTTOM = ns.L["BOTTOM"],
    BOTTOMRIGHT = ns.L["BOTTOMRIGHT"],
}
anchorRelativePointOptions[ns.DEFAULT] = ns.L["Default Relative Point"]

local anchorRelativePointSort = {
    "TOPLEFT",
    "TOP",
    "TOPRIGHT",
    "LEFT",
    "CENTER",
    "RIGHT",
    "BOTTOMLEFT",
    "BOTTOM",
    "BOTTOMRIGHT",
}
table.insert(anchorRelativePointSort, 1, ns.DEFAULT)

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

    optionsTable.anchorPoint = {
        type = "select",
        name = ns.L["Anchor Point"],
        values = anchorPointOptions,
        sorting = anchorPointSort,
        set = "SetAnchorPoint",
        get = "GetAnchorPoint",
        order = orderMap.ANCHOR_POINT,
    }

    optionsTable.relativeTo = {
        type = "select",
        name = ns.L["Relative To"],
        desc = ns.L["RelativeToDesc"],
        values = anchorRelativeToOptions,
        sorting = anchorRelativeToSort,
        set = "SetRelativeTo",
        get = "GetRelativeTo",
        order = orderMap.RELATIVE_TO,
    }

    optionsTable.relativePoint = {
        type = "select",
        name = ns.L["Relative Point"],
        values = anchorRelativePointOptions,
        sorting = anchorRelativePointSort,
        set = "SetRelativePoint",
        get = "GetRelativePoint",
        order = orderMap.RELATIVE_POINT,
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
---@field defaultRelativeTo string?
---@field defaultRelativePoint string?
---@field SetPosition fun(self: PositionableHandler)
---@field _SetPosition fun(self: PositionableHandler, positionable: ScriptRegionResizing)

---@class Positionable: PositionableHandler
local Positionable = {}

---Set the anchor point
---@param info table AceConfig info table
---@param value string The anchor point name
function Positionable:SetAnchorPoint(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".anchorPoint", value)
    self:SetPosition()
end

---Get the anchor point
---@param info? table AceConfig info table
---@return string|nil The anchor point name
function Positionable:GetAnchorPoint(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".anchorPoint")
end

---Set the relative to frame
---@param info table AceConfig info table
---@param value Frame The relative to frame
function Positionable:SetRelativeTo(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".relativeTo", value)
    self:SetPosition()
end

---Get the relative to frame
---@param info? table AceConfig info table
---@return string|nil The relative to frame
function Positionable:GetRelativeTo(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".relativeTo")
end

---Set the relative point
---@param info table AceConfig info table
---@param value string The relative point name
function Positionable:SetRelativePoint(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".relativePoint", value)
    self:SetPosition()
end

---Get the relative point
---@param info? table AceConfig info table
---@return string|nil The relative point name
function Positionable:GetRelativePoint(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".relativePoint")
end

function Positionable:SetXOffset(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".xOffset", value)
    self:SetPosition()
end

--- Get the X offset
--- @param info? table AceConfig info table
--- @return number|nil xOffset
function Positionable:GetXOffset(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".xOffset")
end

function Positionable:SetYOffset(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".yOffset", value)
    self:SetPosition()
end

--- Get the Y offset
--- @param info? table AceConfig info table
--- @return number|nil yOffset
function Positionable:GetYOffset(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".yOffset")
end

function Positionable:_SetPosition(positionable)
    ---@type string | nil
    local relativeTo = self:GetRelativeTo() or ns.DEFAULT
    if relativeTo == ns.DEFAULT then
        relativeTo = self.defaultRelativeTo or nil
    end

    ---@type string | nil
    local relativePoint = self:GetRelativePoint() or ns.DEFAULT
    if relativePoint == ns.DEFAULT then
        relativePoint = self.defaultRelativePoint or nil
    end

    local anchorPoint = self:GetAnchorPoint() or "TOPLEFT"
    local xOffset = self:GetXOffset() or 0
    local yOffset = self:GetYOffset() or 0
    positionable:ClearAllPoints()
    if relativeTo == nil or relativePoint == nil then
        positionable:SetPoint(anchorPoint, xOffset, yOffset)
        return
    end

    if type(relativeTo) == "string" then
        if _G[relativeTo] == nil then
            error("Relative frame '" .. relativeTo .. "' does not exist.")
        else
            relativeTo = _G[relativeTo]
        end
    end

    if relativePoint == nil then
        positionable:SetPoint(
            anchorPoint,
            relativeTo,
            xOffset,
            yOffset
        )
    else
        positionable:SetPoint(
            anchorPoint,
            relativeTo,
            relativePoint,
            xOffset,
            yOffset
        )
    end
end

ns.Positionable = Positionable
