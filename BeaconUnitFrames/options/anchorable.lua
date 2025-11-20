---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddAnchorOptions(optionsTable, orderMap)
    optionsTable.anchorPoint = {
        type = "select",
        name = ns.L["Anchor Point"],
        values = {
            TOPLEFT = ns.L["TOPLEFT"],
            TOP = ns.L["TOP"],
            TOPRIGHT = ns.L["TOPRIGHT"],
            LEFT = ns.L["LEFT"],
            CENTER = ns.L["CENTER"],
            RIGHT = ns.L["RIGHT"],
            BOTTOMLEFT = ns.L["BOTTOMLEFT"],
            BOTTOM = ns.L["BOTTOM"],
            BOTTOMRIGHT = ns.L["BOTTOMRIGHT"],
        },
        set = "SetAnchorPoint",
        get = "GetAnchorPoint",
        order = orderMap.ANCHOR_POINT or 99,
    }

    optionsTable.relativeTo = {
        type = "select",
        name = ns.L["Relative To"],
        desc = ns.L["RelativeToDesc"],
        values = ns.AnchorRelativeToOptions,
        set = "SetRelativeTo",
        get = "GetRelativeTo",
        order = orderMap.RELATIVE_TO or 100,
    }

    optionsTable.relativePoint = {
        type = "select",
        name = ns.L["Relative Point"],
        values = {
            TOPLEFT = ns.L["TOPLEFT"],
            TOP = ns.L["TOP"],
            TOPRIGHT = ns.L["TOPRIGHT"],
            LEFT = ns.L["LEFT"],
            CENTER = ns.L["CENTER"],
            RIGHT = ns.L["RIGHT"],
            BOTTOMLEFT = ns.L["BOTTOMLEFT"],
            BOTTOM = ns.L["BOTTOM"],
            BOTTOMRIGHT = ns.L["BOTTOMRIGHT"],
        },
        set = "SetRelativePoint",
        get = "GetRelativePoint",
        order = orderMap.RELATIVE_POINT or 101,
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
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".relativeTo", value:GetName())
    self:SetPosition()
end

---Get the relative to frame
---@param info table AceConfig info table
---@return Frame|nil The relative to frame
function Anchorable:GetRelativeTo(info)
    local frameName = ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".relativeTo")
    if frameName then
        return _G[frameName]
    end
    return UIParent
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