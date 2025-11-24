---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.Foreground: BUFConfigHandler, StatusBarTexturable, Colorable, ClassColorable, ReactionColorable
local foregroundHandler = {
    configPath = "unitFrames.target.healthBar.foreground",
}

ns.ApplyMixin(ns.StatusBarTexturable, foregroundHandler)
ns.ApplyMixin(ns.Colorable, foregroundHandler)
ns.ApplyMixin(ns.ClassColorable, foregroundHandler)
ns.ApplyMixin(ns.ReactionColorable, foregroundHandler)

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.foreground = {
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useCustomColor = false,
    customColor = { 0, 1, 0, 1 },
    useClassColor = false,
}

local foreground = {
    type = "group",
    handler = foregroundHandler,
    name = ns.L["Foreground"],
    order = BUFTargetHealth.topGroupOrder.FOREGROUND,
    args = {}
}

ns.AddStatusBarTextureOptions(foreground.args)
ns.AddColorOptions(foreground.args)
ns.AddClassColorOptions(foreground.args)
ns.AddReactionColorOptions(foreground.args)

ns.options.args.unitFrames.args.target.args.healthBar.args.foreground = foreground

function foregroundHandler:RefreshConfig()
    self:RefreshStatusBarTexture()
    self:RefreshColor()

    if not self.initialized then
        self.initialized = true

---@diagnostic disable-next-line: undefined-field
        BUFTarget:SecureHook(ns.BUFTarget.healthBar.HealthBarTexture, "SetAtlas", function(_, texture)
            self:RefreshStatusBarTexture()
            self:RefreshColor()
        end)

        BUFTarget:SecureHook(ns.BUFTarget.healthBarContainer.HealthBarMask, "SetAtlas", function(_, texture)
            self:RefreshStatusBarTexture()
            self:RefreshColor()
        end)
    end
end

local function SetStatusTextureWithoutHooks(healthBar, texturePath)
    if BUFTarget:IsHooked(healthBar, "SetStatusBarTexture") then
        BUFTarget:Unhook(healthBar, "SetStatusBarTexture")
    end
    healthBar:SetStatusBarTexture(texturePath)
    BUFTarget:SecureHook(healthBar, "SetStatusBarTexture", function(_, texture)
        foregroundHandler:RefreshStatusBarTexture()
    end)
end

function foregroundHandler:RefreshStatusBarTexture()
    local parent = ns.BUFTarget
    local useCustomTexture = ns.db.profile.unitFrames.target.healthBar.foreground.useStatusBarTexture
    local texturePath = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health"
    if useCustomTexture then
        texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR,
            ns.db.profile.unitFrames.target.healthBar.foreground.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
    end
    SetStatusTextureWithoutHooks(parent.healthBar, texturePath)
end

function foregroundHandler:RefreshColor()
    local parent = ns.BUFTarget
    local useCustomColor = ns.db.profile.unitFrames.target.healthBar.foreground.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.target.healthBar.foreground.useClassColor
    local useReactionColor = ns.db.profile.unitFrames.target.healthBar.foreground.useReactionColor
    if useClassColor and (not useReactionColor or UnitPlayerControlled("target")) then
        local _, class = UnitClass("target")
        local r, g, b = GetClassColor(class)
        parent.healthBar:SetStatusBarColor(r, g, b, 1.0)
    elseif useReactionColor then
        local r, g, b = GameTooltip_UnitColor("target")
        parent.healthBar:SetStatusBarColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.foreground.customColor)
        parent.healthBar:SetStatusBarColor(r, g, b, a)
    end
end

BUFTargetHealth.foregroundHandler = foregroundHandler
