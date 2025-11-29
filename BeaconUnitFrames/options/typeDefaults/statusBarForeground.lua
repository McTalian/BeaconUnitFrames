---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add status bar foreground options to the given options table
--- @param optionsTable table
--- @param _orderMap? BUFOptionsOrder
--- @param handler? StatusBarForeground
function ns.AddStatusBarForegroundOptions(optionsTable, _orderMap, handler)
    local orderMap = _orderMap or ns.defaultOrderMap
    ns.AddColorOptions(optionsTable, orderMap)
    ns.AddStatusBarTextureOptions(optionsTable, orderMap)

    if handler then
        if handler.classColorable then
            ns.AddClassColorOptions(optionsTable, orderMap)
        end
        if handler.reactionColorable then
            ns.AddReactionColorOptions(optionsTable, orderMap)
        end
        if handler.powerColorable then
            ns.AddPowerColorOptions(optionsTable, orderMap)
        end
    end
end

---@class StatusBarForegroundHandler
---@field unit string
---@field statusBar StatusBar
---@field defaultStatusBarTexture? string
---@field statusBarMask? MaskTexture
---@field defaultStatusBarMaskTexture? string
---@field RefreshColor fun(self: StatusBarForeground)
---@field RefreshStatusBarTexture fun(self: StatusBarForeground)

---@class StatusBarForeground: StatusBarForegroundHandler, Colorable, ClassColorable, ReactionColorable, PowerColorable, StatusBarTexturable
local StatusBarForeground = {}

--- Apply mixins to a StatusBarForeground
--- @param self StatusBarForeground
--- @param handler BUFConfigHandler
--- @param classColorable? boolean Whether to apply ClassColorable mixin
--- @param reactionColorable? boolean Whether to apply ReactionColorable mixin
--- @param powerColorable? boolean Whether to apply PowerColorable mixin
function StatusBarForeground:ApplyMixin(handler, classColorable, reactionColorable, powerColorable)
    ns.Mixin(handler, ns.Colorable, ns.StatusBarTexturable)
    if classColorable then
        self.classColorable = true
        ns.Mixin(handler, ns.ClassColorable)
    else
        self.classColorable = false
    end
    if reactionColorable then
        self.reactionColorable = true
        ns.Mixin(handler, ns.ReactionColorable)
    else
        self.reactionColorable = false
    end
    if powerColorable then
        self.powerColorable = true
        ns.Mixin(handler, ns.PowerColorable)
    else
        self.powerColorable = false
    end
    ns.Mixin(handler, self)

    ---@type StatusBarForeground
    handler = handler --[[@as StatusBarForeground]]

    if handler.optionsTable then
        ns.AddStatusBarForegroundOptions(handler.optionsTable.args, handler.orderMap, handler)
    end
end

function StatusBarForeground:RefreshStatusBarConfig()
    self:RefreshStatusBarTexture()
    self:RefreshColor()
end

function StatusBarForeground:RefreshStatusBarTexture()
    local useCustomTexture = self:GetUseStatusBarTexture()
    if useCustomTexture then
        local textureName = self:GetStatusBarTexture()
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, textureName)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        self.statusBar:SetStatusBarTexture(texturePath)
        if self.statusBarMask then
            self.statusBarMask:Hide()
        end
    else
        if self.defaultStatusBarTexture then
            self.statusBar:SetStatusBarTexture(self.defaultStatusBarTexture)
        end
        if self.statusBarMask and self.defaultStatusBarMaskTexture then
            self.statusBarMask:Show()
            self.statusBarMask:SetAtlas(self.defaultStatusBarMaskTexture, true)
        end
    end
end

function StatusBarForeground:RefreshColor()
    local useClassColor = self.classColorable and self:GetUseClassColor()
    local useReactionColor = self.reactionColorable and self:GetUseReactionColor()
    local usePowerColor = self.powerColorable and self:GetUsePowerColor()
    local useCustomColor = self:GetUseCustomColor()

    if useCustomColor then
        local r, g, b, a = self:GetCustomColor()
        self.statusBar:SetStatusBarColor(r, g, b, a)
    elseif useClassColor and (not useReactionColor or UnitPlayerControlled(self.unit)) then
        local _, class = UnitClass(self.unit)
        local r, g, b = GetClassColor(class)
        self.statusBar:SetStatusBarColor(r, g, b, 1)
    elseif useReactionColor then
        local r, g, b = GameTooltip_UnitColor(self.unit)
        self.statusBar:SetStatusBarColor(r, g, b, 1)
    elseif usePowerColor then
        local powerType, powerToken, rX, gY, bZ = UnitPowerType(self.unit)
        local info = PowerBarColor[powerToken]
        local r, g, b
        if info then
            r, g, b = info.r, info.g, info.b
        elseif not rX then
            local info = PowerBarColor[powerType]
            if info then
                r, g, b = info.r, info.g, info.b
            end
        else
            r, g, b = rX, gY, bZ
        end

        self.statusBar:SetStatusBarColor(r, g, b, 1)
    end
end

ns.StatusBarForeground = StatusBarForeground
