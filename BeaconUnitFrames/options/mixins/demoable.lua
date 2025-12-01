---@class BUFNamespace
local ns = select(2, ...)

--- Add demo options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddDemoOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap
	optionsTable.enable = {
		type = "execute",
		name = ns.L["Demo"],
		desc = ns.L["DemoDesc"],
		width = "full",
		func = "ToggleDemoMode",
		order = orderMap.DEMO_MODE,
	}
end

---@class DemoableHandler: BUFConfigHandler
---@field demoMode boolean
---@field ToggleDemoMode fun(self: DemoableHandler)
---@field _ToggleDemoMode fun(self: DemoableHandler, showable: ScriptRegion)

---@class Demoable: DemoableHandler
local Demoable = {}

function Demoable:_ToggleDemoMode(showable)
	if self.demoMode then
		self.demoMode = false
		showable:Hide()
	else
		self.demoMode = true
		showable:Show()
	end
end

ns.Demoable = Demoable
