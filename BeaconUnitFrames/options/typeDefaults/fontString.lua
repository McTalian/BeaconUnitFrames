---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add font string options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddFontStringOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    ns.AddPositionableOptions(optionsTable, orderMap)
    ns.AddSizableOptions(optionsTable, orderMap)
    ns.AddFontOptions(optionsTable, orderMap)
    ns.AddJustifiableOptions(optionsTable, orderMap)
    ns.AddDemoOptions(optionsTable, orderMap)
end

---@class FontStringHandler
---@field RefreshFontStringConfig fun(self: BUFFontString)
---@field fontString FontString
---@field defaultRelativeTo string?
---@field defaultRelativePoint string?
---@field demoText string?

---@class BUFFontString: FontStringHandler, JustifiableHandler, FontableHandler, SizableHandler, PositionableHandler, SizableHandler, DemoableHandler
local BUFFontString = {}

--- Apply mixins to a BUFFontString
---@param self BUFFontString
---@param handler BUFConfigHandler
function BUFFontString:ApplyMixin(handler)
    ns.ApplyMixin(ns.Demoable, handler)
    ns.ApplyMixin(ns.Sizable, handler)
    ns.ApplyMixin(ns.Positionable, handler)
    ns.ApplyMixin(ns.Justifiable, handler)
    ns.ApplyMixin(ns.Fontable, handler)
    ns.ApplyMixin(self, handler)

    if self.optionsTable then
        ns.AddFontStringOptions(self.optionsTable)
    end
end

function BUFFontString:ToggleDemoMode()
    self:_ToggleDemoMode(self.fontString)
    if self.demoText then
        self.fontString:SetText(self.demoText)
    end
end

function BUFFontString:SetSize()
    self:_SetSize(self.fontString)
end

function BUFFontString:SetPosition()
    self:_SetPosition(self.fontString)
end

function BUFFontString:SetFont()
    self:_SetFont(self.fontString)
end

function BUFFontString:UpdateFontColor()
    self:_UpdateFontColor(self.fontString)
end

function BUFFontString:SetFontShadow()
    self:_SetFontShadow(self.fontString)
end

function BUFFontString:UpdateJustification()
    self:_UpdateJustification(self.fontString)
end

function BUFFontString:RefreshFontStringConfig()
    self:SetPosition()
    self:SetSize()
    self:SetFont()
    self:SetFontShadow()
    self:UpdateJustification()
end

ns.BUFFontString = BUFFontString
