---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add horizontal justification options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddHJustifiableOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.customization = optionsTable.customization or {
        type = "header",
        name = ns.L["Text Customization"],
        order = orderMap.CUSTOMIZATION_HEADER,
    }

    optionsTable.justifyH = {
        type = "select",
        name = ns.L["Horizontal Justification"],
        values = {
            LEFT = ns.L["LEFT"],
            CENTER = ns.L["CENTER"],
            RIGHT = ns.L["RIGHT"],
        },
        sorting = {
            "LEFT",
            "CENTER",
            "RIGHT",
        },
        set = "SetJustifyH",
        get = "GetJustifyH",
        order = orderMap.JUSTIFY_H,
    }
end

--- Add vertical justification options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddVJustifiableOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.customization = optionsTable.customization or {
        type = "header",
        name = ns.L["Text Customization"],
        order = orderMap.CUSTOMIZATION_HEADER,
    }

    optionsTable.justifyV = {
        type = "select",
        name = ns.L["Vertical Justification"],
        values = {
            TOP = ns.L["TOP"],
            MIDDLE = ns.L["MIDDLE"],
            BOTTOM = ns.L["BOTTOM"],
        },
        sorting = {
            "TOP",
            "MIDDLE",
            "BOTTOM",
        },
        set = "SetJustifyV",
        get = "GetJustifyV",
        order = orderMap.JUSTIFY_V,
    }
end

--- Add justification options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddJustifiableOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    ns.AddHJustifiableOptions(optionsTable, orderMap)
    ns.AddVJustifiableOptions(optionsTable, orderMap)
end

---@class JustifiableHandler: BUFConfigHandler
---@field UpdateJustification fun(self: JustifiableHandler)

---@class HJustifiable: JustifiableHandler
local HJustifiable = {}

function HJustifiable:SetJustifyH(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".justifyH", value)
    self:UpdateJustification()
end

function HJustifiable:GetJustifyH(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".justifyH")
end

---@class VJustifiable: JustifiableHandler
local VJustifiable = {}

function VJustifiable:SetJustifyV(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".justifyV", value)
    self:UpdateJustification()
end

function VJustifiable:GetJustifyV(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".justifyV")
end

---@class Justifiable: JustifiableHandler
local Justifiable = {}

ns.ApplyMixin(HJustifiable, Justifiable)
ns.ApplyMixin(VJustifiable, Justifiable)

ns.HJustifiable = HJustifiable
ns.VJustifiable = VJustifiable
ns.Justifiable = Justifiable

