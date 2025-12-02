---@class BUFNamespace
local ns = select(2, ...)

--- Add scalable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddScalableOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap

	optionsTable.sizing = optionsTable.sizing
		or {
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

---@class ScalableHandler: MixinBase
---@field SetScaleFactor fun(self: ScalableHandler)
---@field _SetScaleFactor fun(self: ScalableHandler, scalable: Region)

---@class Scalable: ScalableHandler
local Scalable = {}

ns.Mixin(Scalable, ns.MixinBase)

function Scalable:SetScale(info, value)
	self:DbSet("scale", value)
	self:SetScaleFactor()
end

function Scalable:GetScale(info)
	return self:DbGet("scale")
end

function Scalable:_SetScaleFactor(scalable)
	local scale = self:GetScale() or 1.0
	scalable:SetScale(scale)
end

ns.Scalable = Scalable
