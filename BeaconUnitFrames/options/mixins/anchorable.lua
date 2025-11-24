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

---Add anchor options to the given options table
---@param optionsTable table
---@param _orderMap BUFOptionsOrder?
function ns.AddAnchorOptions(optionsTable, _orderMap)
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
end

---@class AnchorableHandler: BUFConfigHandler
---@field SetPosition fun(self: AnchorableHandler)

---@class Anchorable: AnchorableHandler
local Anchorable = {}

---Set the anchor point
---@param info table AceConfig info table
---@param value string The anchor point name
function Anchorable:SetAnchorPoint(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".anchorPoint", value)
    self:SetPosition()
end

---Get the anchor point
---@param info table AceConfig info table
---@return string|nil The anchor point name
function Anchorable:GetAnchorPoint(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".anchorPoint")
end

---Set the relative to frame
---@param info table AceConfig info table
---@param value Frame The relative to frame
function Anchorable:SetRelativeTo(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".relativeTo", value)
    self:SetPosition()
end

---Get the relative to frame
---@param info table AceConfig info table
---@return Frame|nil The relative to frame
function Anchorable:GetRelativeTo(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".relativeTo")
end

---Set the relative point
---@param info table AceConfig info table
---@param value string The relative point name
function Anchorable:SetRelativePoint(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".relativePoint", value)
    self:SetPosition()
end

---Get the relative point
---@param info table AceConfig info table
---@return string|nil The relative point name
function Anchorable:GetRelativePoint(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".relativePoint")
end

ns.Anchorable = Anchorable