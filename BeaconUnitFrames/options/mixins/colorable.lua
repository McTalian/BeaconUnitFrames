---@class BUFNamespace
local ns = select(2, ...)

--- Add color options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddColorOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap

	optionsTable.coloring = optionsTable.coloring
		or {
			type = "header",
			name = ns.L["Coloring"],
			order = orderMap.COLORING_HEADER,
		}

	optionsTable.useCustomColor = {
		type = "toggle",
		name = ns.L["Use Custom Color"],
		desc = ns.L["UseCustomColorDesc"],
		set = "SetUseCustomColor",
		get = "GetUseCustomColor",
		order = orderMap.USE_CUSTOM_COLOR,
	}

	optionsTable.customColor = {
		type = "color",
		name = ns.L["Custom Color"],
		hasAlpha = true,
		disabled = "IsCustomColorDisabled",
		set = "SetCustomColor",
		get = "GetCustomColor",
		order = orderMap.CUSTOM_COLOR,
	}
end

---@class ColorableHandler: MixinBase
---@field RefreshColor fun(self: ColorableHandler)

---@class Colorable: ColorableHandler
local Colorable = {}

ns.Mixin(Colorable, ns.MixinBase)

---Set whether to use a custom color
---@param info table AceConfig info table
---@param value boolean Whether to use custom color
function Colorable:SetUseCustomColor(info, value)
	self:DbSet("useCustomColor", value)
	self:RefreshColor()
end

---Get whether to use a custom color
---@param info? table AceConfig info table
---@return boolean|nil Whether to use custom color
function Colorable:GetUseCustomColor(info)
	return self:DbGet("useCustomColor")
end

---Set the custom color
---@param info table AceConfig info table
---@param r number Red component (0-1)
---@param g number Green component (0-1)
---@param b number Blue component (0-1)
---@param a number Alpha component (0-1)
function Colorable:SetCustomColor(info, r, g, b, a)
	self:DbSet("customColor", { r, g, b, a })
	self:RefreshColor()
end

---Get the custom color
---@param info? table AceConfig info table
---@return number r Red component
---@return number g Green component
---@return number b Blue component
---@return number a Alpha component
function Colorable:GetCustomColor(info)
	local color = self:DbGet("customColor")
	if color then
		return unpack(color)
	end
	return 1, 1, 1, 1 -- default white
end

---Check if custom color selection is disabled
---@param info table AceConfig info table
---@return boolean Whether custom color selection is disabled
function Colorable:IsCustomColorDisabled(info)
	return self:DbGet("useCustomColor") == false
end

ns.Colorable = Colorable
