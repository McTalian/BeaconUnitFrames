---@class BUFNamespace
local ns = select(2, ...)

--- Add texture options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
--- @param noAtlas boolean?
function ns.AddTextureOptions(optionsTable, _orderMap, noAtlas)
	local orderMap = _orderMap or ns.defaultOrderMap
	ns.AddPositionableOptions(optionsTable, orderMap)
	if noAtlas then
		ns.AddSizableOptions(optionsTable, orderMap)
		ns.AddScalableOptions(optionsTable, orderMap)
	else
		ns.AddAtlasSizableOptions(optionsTable, ns.AtlasSizableFlags.SIZABLE + ns.AtlasSizableFlags.SCALABLE, orderMap)
	end
	ns.AddDemoOptions(optionsTable, orderMap)
end

---@class TextureHandler
---@field RefreshTextureConfig fun(self: BUFTexture)
---@field texture Texture

---@class BUFTexture: TextureHandler, AtlasSizable, Sizable, Scalable, Positionable, Demoable
local BUFTexture = {}

--- Apply mixins to a BUFTexture
--- @param self BUFTexture
--- @param handler BUFConfigHandler
--- @param skipOptions boolean?
function BUFTexture:ApplyMixin(handler, skipOptions)
	if handler.noAtlas then
		ns.Mixin(handler, ns.Sizable, ns.Scalable)
	else
		ns.AtlasSizable:ApplyMixin(handler, ns.AtlasSizableFlags.SIZABLE + ns.AtlasSizableFlags.SCALABLE)
	end
	ns.Mixin(handler, ns.Demoable, ns.Positionable, self)

	if handler.optionsTable and not skipOptions then
		ns.AddTextureOptions(handler.optionsTable.args, handler.optionsOrder, handler.noAtlas)
	end
end

function BUFTexture:ToggleDemoMode()
	self:_ToggleDemoMode(self.texture)
end

function BUFTexture:SetSize()
	self:_SetSize(self.texture)
end

function BUFTexture:SetPosition()
	self:_SetPosition(self.texture)
end

function BUFTexture:SetScaleFactor()
	self:_SetScaleFactor(self.texture)
end

function BUFTexture:RefreshTextureConfig()
	self:SetSize()
	self:SetPosition()
	self:SetScaleFactor()
end

ns.BUFTexture = BUFTexture
