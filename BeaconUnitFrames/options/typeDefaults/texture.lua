---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add texture options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddTextureOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    ns.AddPositionableOptions(optionsTable, orderMap)
    ns.AddAtlasSizableOptions(optionsTable, ns.AtlasSizableFlags.SIZABLE + ns.AtlasSizableFlags.SCALABLE, orderMap)
    ns.AddDemoOptions(optionsTable, orderMap)
end

---@class TextureHandler
---@field RefreshTextureConfig fun(self: BUFTexture)
---@field texture Texture
---@field defaultRelativeTo string?
---@field defaultRelativePoint string?

---@class BUFTexture: TextureHandler, AtlasSizable, Positionable, Demoable
local BUFTexture = {}

--- Apply mixins to a BUFTexture
--- @param self BUFTexture
--- @param handler BUFConfigHandler
function BUFTexture:ApplyMixin(handler)
    ns.AtlasSizable:ApplyMixin(handler, ns.AtlasSizableFlags.SIZABLE + ns.AtlasSizableFlags.SCALABLE)
    ns.Mixin(handler, ns.Demoable, ns.Positionable, self)

    if self.optionsTable then
        ns.AddTextureOptions(self.optionsTable, self.orderMap)
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
