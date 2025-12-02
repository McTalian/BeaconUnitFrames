---@class BUFNamespace
local ns = select(2, ...)

function ns.AddStatusBarOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap
	ns.AddSizableOptions(optionsTable, orderMap)
	ns.AddPositionableOptions(optionsTable, orderMap)
	ns.AddFrameLevelOption(optionsTable, orderMap)
end

---@class StatusBarHandler
---@field unit string
---@field barOrContainer Frame
---@field positionMask? boolean
---@field foregroundHandler? StatusBarForeground
---@field backgroundHandler? StatusBarBackground
---@field leftTextHandler? BUFFontString
---@field rightTextHandler? BUFFontString
---@field centerTextHandler? BUFFontString
---@field deadTextHandler? BUFFontString
---@field unconsciousTextHandler? BUFFontString

---@class BUFStatusBar: StatusBarHandler, Sizable, Positionable, Levelable
local BUFStatusBar = {}

--- Apply mixins to a BUFStatusBar
--- @param self BUFStatusBar
--- @param handler BUFConfigHandler
function BUFStatusBar:ApplyMixin(handler)
	ns.Mixin(handler, ns.Sizable, ns.Positionable, ns.Levelable, self)

	if handler.optionsTable then
		ns.AddStatusBarOptions(handler.optionsTable.args, handler.optionsOrder)
	end
end

--- Refresh the status bar configuration
--- @param self BUFStatusBar
function BUFStatusBar:RefreshStatusBarConfig()
	self:SetPosition()
	self:SetSize()
	self:SetLevel()

	if self.leftTextHandler then
		self.leftTextHandler:RefreshConfig()
	end
	if self.rightTextHandler then
		self.rightTextHandler:RefreshConfig()
	end
	if self.centerTextHandler then
		self.centerTextHandler:RefreshConfig()
	end
	if self.deadTextHandler then
		self.deadTextHandler:RefreshConfig()
	end
	if self.unconsciousTextHandler then
		self.unconsciousTextHandler:RefreshConfig()
	end
	if self.foregroundHandler then
		self.foregroundHandler:RefreshConfig()
	end
	if self.backgroundHandler then
		self.backgroundHandler:RefreshConfig()
	end
end

function BUFStatusBar:SetSize()
	self:_SetSize(self.barOrContainer)
end

function BUFStatusBar:SetPosition()
	self:_SetPosition(self.barOrContainer)
end

function BUFStatusBar:SetLevel()
	self:_SetLevel(self.barOrContainer)
end

ns.BUFStatusBar = BUFStatusBar
