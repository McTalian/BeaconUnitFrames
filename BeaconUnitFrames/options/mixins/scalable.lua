---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add scalable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddScalableOptions(optionsTable, _orderMap)
  local orderMap = _orderMap or ns.defaultOrderMap

  optionsTable.sizing = optionsTable.sizing or {
    type = "header",
    name = ns.L["Sizing"],
    order = orderMap.SIZING_HEADER,
  }

  optionsTable.scale = {
      type = "range",
      name = ns.L["Scale"],
      desc = ns.L["ScaleDesc"],
      min = 0.1,
      softMin = 0.5,
      softMax = 3.0,
      max = 10.0,
      step = 0.01,
      bigStep = 0.05,
      set = "SetScale",
      get = "GetScale",
      order = orderMap.SCALE,
  }
end

---@class ScalableHandler: BUFConfigHandler
---@field SetScaleFactor fun(self: ScalableHandler)

---@class Scalable: ScalableHandler
local Scalable = {}

function Scalable:SetScale(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".scale", value)
    self:SetScaleFactor()
end

function Scalable:GetScale(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".scale")
end

ns.Scalable = Scalable
