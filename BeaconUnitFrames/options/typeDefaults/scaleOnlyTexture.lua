---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add texture options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddScaleTextureOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    ns.AddPositionableOptions(optionsTable, orderMap)
    ns.AddAtlasSizableOptions(optionsTable, ns.AtlasSizableFlags.SCALABLE, orderMap)
    ns.AddDemoOptions(optionsTable, orderMap)
end

---@class ScaleTextureHandler
---@field RefreshScaleTextureConfig fun(self: BUFScaleTexture)
---@field texture Texture
---@field defaultRelativeTo string?
---@field defaultRelativePoint string?

---@class BUFScaleTexture: ScaleTextureHandler, AtlasSizable, Positionable, Demoable
local BUFScaleTexture = {}

--- Apply mixins to a BUFScaleTexture
--- @param self BUFScaleTexture
--- @param handler BUFConfigHandler
function BUFScaleTexture:ApplyMixin(handler)
    ns.AtlasSizable:ApplyMixin(handler, ns.AtlasSizableFlags.SCALABLE)
    ns.Mixin(handler, ns.Demoable, ns.Positionable, self)

    if handler.optionsTable then
        ns.AddScaleTextureOptions(handler.optionsTable.args, handler.orderMap)
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
