---@class BUFNamespace
local ns = select(2, ...)

--- Add text customizable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
ns.AddTextCustomizableOptions = function(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap

	optionsTable.customization = optionsTable.customization
		or {
			type = "header",
			name = ns.L["Text Customization"],
			order = orderMap.CUSTOMIZATION_HEADER,
		}

	optionsTable.customText = {
		type = "input",
		name = ns.L["Custom Text"],
		desc = ns.L["CustomTextDesc"],
		set = "SetCustomText",
		get = "GetCustomText",
		order = orderMap.CUSTOM_TEXT,
	}
end

---@class TextCustomizableHandler: MixinBase
---@field RefreshText fun(self: TextCustomizableHandler)

---@class TextCustomizable: TextCustomizableHandler
local TextCustomizable = {}

ns.Mixin(TextCustomizable, ns.MixinBase)

---Set the custom text
---@param info table AceConfig info table
---@param value string The custom text
function TextCustomizable:SetCustomText(info, value)
	self:DbSet("customText", value)
	self:RefreshText()
end

---Get the custom text
---@param info table AceConfig info table
---@return string|nil The custom text
function TextCustomizable:GetCustomText(info)
	return self:DbGet("customText")
end

ns.TextCustomizable = TextCustomizable
