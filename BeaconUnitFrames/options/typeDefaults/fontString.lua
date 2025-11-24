---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add font string options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddFontStringOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    ns.AddAnchorOptions(optionsTable, orderMap)
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

---@class BUFFontString: FontStringHandler, FontableHandler, SizableHandler, AnchorableHandler, PositionableHandler, SizableHandler, DemoableHandler
local BUFFontString = {}

--- Apply mixins to a BUFFontString
---@param self BUFFontString
---@param handler BUFConfigHandler
function BUFFontString:ApplyMixin(handler)
    ns.ApplyMixin(ns.Fontable, handler)
    ns.ApplyMixin(ns.Justifiable, handler)
    ns.ApplyMixin(ns.Sizable, handler)
    ns.ApplyMixin(ns.Anchorable, handler)
    ns.ApplyMixin(ns.Positionable, handler)
    ns.ApplyMixin(ns.Demoable, handler)
    ns.ApplyMixin(self, handler)
end

function BUFFontString:ToggleDemoMode()
    if self.demoMode then
        self.demoMode = false
        self.fontString:Hide()
    else
        self.demoMode = true
        self.fontString:Show()
        if self.demoText then
            self.fontString:SetText(self.demoText)
        end
    end
end

function BUFFontString:SetSize()
    local handlerDB = ns.DbUtils.getPath(ns.db.profile, self.configPath, true)
---@diagnostic disable: need-check-nil (getPath will throw if missing)
    if handlerDB.width then
        self.fontString:SetWidth(handlerDB.width)
    end
    if handlerDB.height then
        self.fontString:SetHeight(handlerDB.height)
    end
---@diagnostic enable: need-check-nil
end

function BUFFontString:SetPosition()
    local handlerDB = ns.DbUtils.getPath(ns.db.profile, self.configPath, true)
---@diagnostic disable: need-check-nil (getPath will throw if missing)
    local relativeTo = handlerDB.relativeTo
    if relativeTo == "BUF_IGNORE_DEFAULT" then
        relativeTo = self.defaultRelativeTo or nil
    end

    local relativePoint = handlerDB.relativePoint
    if relativePoint == "BUF_IGNORE_DEFAULT" then
        relativePoint = self.defaultRelativePoint or nil
    end

    self.fontString:ClearAllPoints()
    if relativeTo == nil or relativePoint == nil then
        self.fontString:SetPoint(handlerDB.anchorPoint, handlerDB.xOffset, handlerDB.yOffset)
        return
    end

    if type(relativeTo) == "string" then
        if _G[relativeTo] == nil then
            error("Relative frame '" .. relativeTo .. "' does not exist.")
        else
            relativeTo = _G[relativeTo]
        end
    end

    if relativePoint == nil then
        self.fontString:SetPoint(
            handlerDB.anchorPoint,
            relativeTo,
            handlerDB.xOffset or 0,
            handlerDB.yOffset or 0
        )
    else
        self.fontString:SetPoint(
            handlerDB.anchorPoint,
            relativeTo,
            relativePoint,
            handlerDB.xOffset or 0,
            handlerDB.yOffset or 0
        )
    end
---@diagnostic enable: need-check-nil
end

function BUFFontString:SetFont()
    local handlerDB = ns.DbUtils.getPath(ns.db.profile, self.configPath, true)
---@diagnostic disable: need-check-nil (getPath will throw if missing)
    local useFontObjects = handlerDB.useFontObjects
    if useFontObjects then
        local fontObjectName = handlerDB.fontObject
        if _G[fontObjectName] == nil then
            error("Font object '" .. fontObjectName .. "' does not exist.")
        end
        self.fontString:SetFontObject(_G[fontObjectName])
    else
        local fontFace = handlerDB.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            print("Font face '" .. fontFace .. "' not found. Using: ", STANDARD_TEXT_FONT)
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = handlerDB.fontSize
        local fontFlagsTable = handlerDB.fontFlags
        local fontFlags = ns.FontFlagsToString(fontFlagsTable)
        self.fontString:SetFont(fontPath, fontSize, fontFlags)
    end

    self:UpdateFontColor()
---@diagnostic enable: need-check-nil
end

function BUFFontString:UpdateFontColor()
    local handlerDB = ns.DbUtils.getPath(ns.db.profile, self.configPath, true)
---@diagnostic disable: need-check-nil (getPath will throw if missing)
    local r, g, b, a = unpack(handlerDB.fontColor)
    self.fontString:SetTextColor(r, g, b, a)
---@diagnostic enable: need-check-nil
end

function BUFFontString:SetFontShadow()
    local handlerDB = ns.DbUtils.getPath(ns.db.profile, self.configPath, true)
---@diagnostic disable: need-check-nil (getPath will throw if missing)
    local useFontObjects = handlerDB.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(handlerDB.fontShadowColor)
    local offsetX = handlerDB.fontShadowOffsetX
    local offsetY = handlerDB.fontShadowOffsetY
    if a == 0 then
        self.fontString:SetShadowOffset(0, 0)
    else
        self.fontString:SetShadowColor(r, g, b, a)
        self.fontString:SetShadowOffset(offsetX, offsetY)
    end
---@diagnostic enable: need-check-nil
end

function BUFFontString:UpdateJustification()
    local handlerDB = ns.DbUtils.getPath(ns.db.profile, self.configPath, true)
---@diagnostic disable: need-check-nil (getPath will throw if missing)
    local justifyH = handlerDB.justifyH or "LEFT"
    local justifyV = handlerDB.justifyV or "TOP"
    self.fontString:SetJustifyH(justifyH)
    self.fontString:SetJustifyV(justifyV)
---@diagnostic enable: need-check-nil
end

function BUFFontString:RefreshFontStringConfig()
    self:SetPosition()
    self:SetSize()
    self:SetFont()
    self:SetFontShadow()
    self:UpdateJustification()
end

ns.BUFFontString = BUFFontString
