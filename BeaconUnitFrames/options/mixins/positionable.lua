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
    ["TargetFrame"] = HUD_EDIT_MODE_TARGET_FRAME_LABEL,
    ["PlayerFrame"] = HUD_EDIT_MODE_PLAYER_FRAME_LABEL,
    ["FocusFrame"] = HUD_EDIT_MODE_FOCUS_FRAME_LABEL,
    ["PetFrame"] = HUD_EDIT_MODE_PET_FRAME_LABEL,
}
anchorRelativeToOptions[ns.DEFAULT] = ns.L["Default Relative Frame"]

--- Helper to get the relative frame from a string key
--- @param strKey string
--- @return Frame | string
function ns.GetRelativeFrame(strKey)
    if strKey == ns.DEFAULT then return ns.DEFAULT
    elseif strKey == "UIParent" then return _G.UIParent
    elseif strKey == "TargetFrame" then return _G.TargetFrame
    elseif strKey == "PlayerFrame" then return _G.PlayerFrame
    elseif strKey == "FocusFrame" then return _G.FocusFrame
    elseif strKey == "PetFrame" then return _G.PetFrame
    end

    -- Catch-all for other global frames
    if _G[strKey] == nil then
        error("Relative frame '" .. strKey .. "' does not exist.")
    end
    return _G[strKey]
end

local anchorRelativeToSort = {
    ns.DEFAULT,
    "UIParent",
    "TargetFrame",
    "PlayerFrame",
    "FocusFrame",
    "PetFrame",
}

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
---@field defaultRelativeTo string | Frame?
---@field defaultRelativePoint string?
---@field GetRelativeFrame fun(self: PositionableHandler): Frame
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

---@class AnchorInfo
---@field point string
---@field relativeTo Frame
---@field relativePoint string
---@field xOffset number
---@field yOffset number

function Positionable:GetPositionAnchorInfo()
    ---@type string | Frame
    local relativeTo = self:GetRelativeFrame()
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
    ---@type Frame
    local relFrame

    if type(relativeTo) == "string" then
        if _G[relativeTo] == nil then
            error("Relative frame '" .. relativeTo .. "' does not exist.")
        else
            ---@type Frame
            relFrame = _G[relativeTo] --[[@as Frame]]
        end
    elseif relativeTo ~= nil then
        relFrame = relativeTo
    end

    ---@type AnchorInfo
    local anchorInfo = {
        point = anchorPoint,
        relativeTo = relFrame,
        relativePoint = relativePoint,
        xOffset = xOffset,
        yOffset = yOffset,
    }

    return anchorInfo
end

function Positionable:_SetPosition(positionable)
    local anchorInfo = self:GetPositionAnchorInfo()

    local anchorPoint = anchorInfo.point
    local relativeTo = anchorInfo.relativeTo
    local relativePoint = anchorInfo.relativePoint
    local xOffset = anchorInfo.xOffset
    local yOffset = anchorInfo.yOffset
    
    positionable:ClearAllPoints()
    if relativeTo == nil or relativePoint == nil then
        positionable:SetPoint(anchorPoint, xOffset, yOffset)
        return
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

function Positionable:_GetRelativeFrame()
    return ns.GetRelativeFrame(self:GetRelativeTo() or ns.DEFAULT)
end

--- Can be overridden by the implementing class to provide a custom relative frame
function Positionable:GetRelativeFrame()
    return self:_GetRelativeFrame()
end

ns.Positionable = Positionable
