---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.Foreground: BUFConfigHandler, StatusBarTexturable, Colorable, ClassColorable
local foregroundHandler = {
    configPath = "unitFrames.player.healthBar.foreground",
}

ns.Mixin(foregroundHandler, ns.StatusBarTexturable, ns.Colorable, ns.ClassColorable)

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar

ns.dbDefaults.profile.unitFrames.player.healthBar.foreground = {
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
    order = BUFPlayerHealth.topGroupOrder.FOREGROUND,
    args = {}
}

ns.AddStatusBarTextureOptions(foreground.args)
ns.AddColorOptions(foreground.args)
ns.AddClassColorOptions(foreground.args)

ns.options.args.unitFrames.args.player.args.healthBar.args.foreground = foreground

function foregroundHandler:RefreshConfig()
    self:RefreshStatusBarTexture()
    self:RefreshColor()
end

function foregroundHandler:RefreshStatusBarTexture()
    local parent = ns.BUFPlayer
    local useCustomTexture = ns.db.profile.unitFrames.player.healthBar.foreground.useStatusBarTexture
    if useCustomTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR,
            ns.db.profile.unitFrames.player.healthBar.foreground.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.healthBar:SetStatusBarTexture(texturePath)
        BUFPlayerHealth:SetLevel()
    else
        parent.healthBar:SetStatusBarTexture("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health")
    end
end

function foregroundHandler:RefreshColor()
    local parent = ns.BUFPlayer
    local useCustomColor = ns.db.profile.unitFrames.player.healthBar.foreground.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.player.healthBar.foreground.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.healthBar:SetStatusBarColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.foreground.customColor)
        parent.healthBar:SetStatusBarColor(r, g, b, a)
    end
end

BUFPlayerHealth.foregroundHandler = foregroundHandler
