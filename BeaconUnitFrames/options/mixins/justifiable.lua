---@class BUFNamespace
local ns = select(2, ...)

--- Add horizontal justification options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddHJustifiableOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap

	optionsTable.customization = optionsTable.customization
		or {
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

	optionsTable.customization = optionsTable.customization
		or {
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

---@class JustifiableHandler: MixinBase
---@field UpdateJustification fun(self: JustifiableHandler)
---@field _UpdateJustification fun(self: JustifiableHandler, justifiable: FontString)

---@class HJustifiable: JustifiableHandler
local HJustifiable = {}

ns.Mixin(HJustifiable, ns.MixinBase)

function HJustifiable:SetJustifyH(info, value)
	self:DbSet("justifyH", value)
	self:UpdateJustification()
end

function HJustifiable:GetJustifyH(info)
	return self:DbGet("justifyH")
end

function HJustifiable:_UpdateJustification(justifiable)
	local justifyH = self:GetJustifyH()
	if justifyH then
		justifiable:SetJustifyH(justifyH)
	end
end

---@class VJustifiable: JustifiableHandler
local VJustifiable = {}

ns.Mixin(VJustifiable, ns.MixinBase)

function VJustifiable:SetJustifyV(info, value)
	self:DbSet("justifyV", value)
	self:UpdateJustification()
end

function VJustifiable:GetJustifyV(info)
	return self:DbGet("justifyV")
end

function VJustifiable:_UpdateJustification(justifiable)
	local justifyV = self:GetJustifyV()
	if justifyV then
		justifiable:SetJustifyV(justifyV)
	end
end

---@class Justifiable: JustifiableHandler, HJustifiable, VJustifiable
local Justifiable = {}

ns.Mixin(Justifiable, HJustifiable, VJustifiable)

function Justifiable:_UpdateJustification(justifiable)
	local justifyH = self:GetJustifyH()
	local justifyV = self:GetJustifyV()
	if justifyH then
		justifiable:SetJustifyH(justifyH)
	end
	if justifyV then
		justifiable:SetJustifyV(justifyV)
	end
end

ns.HJustifiable = HJustifiable
ns.VJustifiable = VJustifiable
ns.Justifiable = Justifiable
