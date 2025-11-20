---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.Foreground: BUFConfigHandler, StatusBarTexturable, Colorable, ClassColorable
local foregroundHandler = {
    configPath = "unitFrames.target.healthBar.foreground",
}

ns.ApplyMixin(ns.StatusBarTexturable, foregroundHandler)
ns.ApplyMixin(ns.Colorable, foregroundHandler)
ns.ApplyMixin(ns.ClassColorable, foregroundHandler)

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

ns.dbDefaults.profile.unitFrames.target.healthBar.foreground = {
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useCustomColor = false,
    customColor = { 0, 1, 0, 1 },
    useClassColor = false,
}

local foregroundOrder = {
    USE_STATUS_BAR_TEXTURE = 1,
    STATUS_BAR_TEXTURE = 2,
    USE_CUSTOM_COLOR = 3,
    CUSTOM_COLOR = 4,
    CLASS_COLOR = 5,
}

local foreground = {
    type = "group",
    handler = foregroundHandler,
    name = ns.L["Foreground"],
    order = BUFTargetHealth.topGroupOrder.FOREGROUND,
    args = {}
}

ns.AddStatusBarTextureOptions(foreground.args, foregroundOrder)
ns.AddColorOptions(foreground.args, foregroundOrder)
ns.AddClassColorOptions(foreground.args, foregroundOrder)

ns.options.args.unitFrames.args.target.args.healthBar.args.foreground = foreground

function foregroundHandler:RefreshConfig()
    self:RefreshStatusBarTexture()
    self:RefreshColor()
end

function foregroundHandler:RefreshStatusBarTexture()
    local parent = ns.BUFTarget
    local useCustomTexture = ns.db.profile.unitFrames.target.healthBar.foreground.useStatusBarTexture
    if useCustomTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR,
            ns.db.profile.unitFrames.target.healthBar.foreground.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.healthBar:SetStatusBarTexture(texturePath)
        BUFTargetHealth:SetLevel()
    else
        parent.healthBar:SetStatusBarTexture("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health")
    end
end

function foregroundHandler:RefreshColor()
    local parent = ns.BUFTarget
    local useCustomColor = ns.db.profile.unitFrames.target.healthBar.foreground.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.target.healthBar.foreground.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.healthBar:SetStatusBarColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.foreground.customColor)
        parent.healthBar:SetStatusBarColor(r, g, b, a)
    end
end

BUFTargetHealth.foregroundHandler = foregroundHandler
