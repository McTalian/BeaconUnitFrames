---@class BUFNamespace
local ns = select(2, ...)

--- Add texture options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddScaleTextureOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap
	ns.AddPositionableOptions(optionsTable, orderMap)
	ns.AddScalableOptions(optionsTable, orderMap)
	ns.AddDemoOptions(optionsTable, orderMap)
end

---@class ScaleTextureHandler
---@field RefreshScaleTextureConfig fun(self: BUFScaleTexture)
---@field texture Texture

---@class BUFScaleTexture: ScaleTextureHandler, Scalable, Positionable, Demoable
local BUFScaleTexture = {}

--- Apply mixins to a BUFScaleTexture
--- @param self BUFScaleTexture
--- @param handler BUFConfigHandler
function BUFScaleTexture:ApplyMixin(handler)
	ns.Mixin(handler, ns.Demoable, ns.Scalable, ns.Positionable, self)

	---@type BUFScaleTexture
	handler = handler --[[@as BUFScaleTexture]]

	if handler.optionsTable then
		ns.AddScaleTextureOptions(handler.optionsTable.args, handler.optionsOrder)
	end
end

function BUFScaleTexture:ToggleDemoMode()
	self:_ToggleDemoMode(self.texture)
end

function BUFScaleTexture:SetPosition()
	self:_SetPosition(self.texture)
end

function BUFScaleTexture:SetScaleFactor()
	self:_SetScaleFactor(self.texture)
end

function BUFScaleTexture:RefreshScaleTextureConfig()
	self:SetPosition()
	self:SetScaleFactor()
end

ns.BUFScaleTexture = BUFScaleTexture
