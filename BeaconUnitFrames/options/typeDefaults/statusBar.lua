---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddStatusBarOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    ns.AddSizableOptions(optionsTable, orderMap)
    ns.AddPositionableOptions(optionsTable, orderMap)
    ns.AddFrameLevelOption(optionsTable, orderMap)
end

---@class StatusBarHandler
---@field unit string
---@field barOrContainer Frame
---@field coeffs? table
---@field maskTexture? MaskTexture
---@field maskTextureAtlas? string
---@field positionMask? boolean
---@field foregroundHandler? StatusBarForeground
---@field backgroundHandler? table StatusBarBackground
---@field leftTextHandler? BUFFontString
---@field rightTextHandler? BUFFontString
---@field centerTextHandler? BUFFontString
---@field deadTextHandler? BUFFontString
---@field unconsciousTextHandler? BUFFontString

---@class BUFStatusBar: BUFConfigHandler, StatusBarHandler, Sizable, Positionable, Levelable
local BUFStatusBar = {}

--- Apply mixins to a BUFStatusBar
--- @param self BUFStatusBar
--- @param handler BUFConfigHandler
function BUFStatusBar:ApplyMixin(handler)
    ns.Mixin(handler, ns.Sizable, ns.Positionable, ns.Levelable, self)

    if handler.optionsTable then
        ns.AddStatusBarOptions(handler.optionsTable.args, handler.orderMap)
    end
end

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
    if self.maskTexture then
        local width = self:GetWidth()
        local height = self:GetHeight()
        local coeffs = self.coeffs or {}
        local maskWidth = width * (coeffs.maskWidth or 1.0)
        local maskHeight = height * (coeffs.maskHeight or 1.0)
        if self.maskTextureAtlas then
            self.maskTexture:SetAtlas(self.maskTextureAtlas, false)
        end
        self.maskTexture:SetWidth(maskWidth)
        self.maskTexture:SetHeight(maskHeight)
        if self.positionMask then
            local xOffset = width * (coeffs.maskXOffset or 0.0)
            local yOffset = height * (coeffs.maskYOffset or 0.0)
            self.maskTexture:SetPoint("TOPLEFT", xOffset, yOffset)
        end
    end
end

function BUFStatusBar:SetPosition()
    self:_SetPosition(self.barOrContainer)
end

function BUFStatusBar:SetLevel()
    self:_SetLevel(self.barOrContainer)
end


ns.BUFStatusBar = BUFStatusBar
