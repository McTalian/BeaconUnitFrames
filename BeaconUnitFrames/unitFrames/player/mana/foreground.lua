---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Mana
local BUFPlayerMana = BUFPlayer.Mana

---@class BUFPlayer.Mana.Foreground: BUFConfigHandler, StatusBarTexturable, Colorable
local foregroundHandler = {
    configPath = "unitFrames.player.manaBar.foreground",
}

BUFPlayerMana.foregroundHandler = foregroundHandler

ns.ApplyMixin(ns.StatusBarTexturable, foregroundHandler)
ns.ApplyMixin(ns.Colorable, foregroundHandler)

---@class BUFDbSchema.UF.Player.Mana
ns.dbDefaults.profile.unitFrames.player.manaBar = ns.dbDefaults.profile.unitFrames.player.manaBar

ns.dbDefaults.profile.unitFrames.player.manaBar.foreground = {
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useCustomColor = false,
    customColor = { 0, 0, 1, 1 },
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
    order = BUFPlayerMana.topGroupOrder.FOREGROUND,
    args = {}
}

ns.AddStatusBarTextureOptions(foreground.args, foregroundOrder)
ns.AddColorOptions(foreground.args, foregroundOrder)

ns.options.args.unitFrames.args.player.args.manaBar.args.foreground = foreground

function foregroundHandler:RefreshConfig()
    self:RefreshStatusBarTexture()
    self:RefreshColor()
end

function foregroundHandler:RefreshStatusBarTexture()
    local parent = ns.BUFPlayer
    local useCustomTexture = ns.db.profile.unitFrames.player.manaBar.foreground.useStatusBarTexture
    if useCustomTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR,
            ns.db.profile.unitFrames.player.manaBar.foreground.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.manaBar:SetStatusBarTexture(texturePath)
        BUFPlayerMana:SetLevel()
    else
        parent.manaBar:SetStatusBarTexture("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana")
    end
end

function foregroundHandler:RefreshColor()
    local parent = ns.BUFPlayer
    local useCustomColor = ns.db.profile.unitFrames.player.manaBar.foreground.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.player.manaBar.foreground.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.manaBar:SetStatusBarColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.manaBar.foreground.customColor)
        parent.manaBar:SetStatusBarColor(r, g, b, a)
    end
end