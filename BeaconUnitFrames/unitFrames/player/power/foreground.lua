---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.Foreground: BUFConfigHandler, StatusBarTexturable, Colorable, PowerColorable
local foregroundHandler = {
    configPath = "unitFrames.player.powerBar.foreground",
}

BUFPlayerPower.foregroundHandler = foregroundHandler

ns.ApplyMixin(ns.StatusBarTexturable, foregroundHandler)
ns.ApplyMixin(ns.Colorable, foregroundHandler)
ns.ApplyMixin(ns.PowerColorable, foregroundHandler)

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.foreground = {
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useCustomColor = false,
    customColor = { 0, 0, 1, 1 },
    usePowerColor = false,
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
    order = BUFPlayerPower.topGroupOrder.FOREGROUND,
    args = {}
}

ns.AddStatusBarTextureOptions(foreground.args, foregroundOrder)
ns.AddColorOptions(foreground.args, foregroundOrder)
ns.AddPowerColorOptions(foreground.args, foregroundOrder)

ns.options.args.unitFrames.args.player.args.powerBar.args.foreground = foreground

function foregroundHandler:RefreshConfig()
    self:RefreshStatusBarTexture()
    self:RefreshColor()
end

function foregroundHandler:RefreshStatusBarTexture()
    local parent = ns.BUFPlayer
    local useCustomTexture = ns.db.profile.unitFrames.player.powerBar.foreground.useStatusBarTexture
    if useCustomTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR,
            ns.db.profile.unitFrames.player.powerBar.foreground.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        if BUFPlayer:IsHooked(parent.manaBar, "SetStatusBarTexture") then
            BUFPlayer:Unhook(parent.manaBar, "SetStatusBarTexture")
        end
        parent.manaBar:SetStatusBarTexture(texturePath)
        BUFPlayer:SecureHook(parent.manaBar, "SetStatusBarTexture", function(_, texture)
            self:RefreshStatusBarTexture()
        end)
        -- BUFPlayerPower:SetLevel()
    else
        parent.manaBar:SetStatusBarTexture("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana")
    end
end

function foregroundHandler:RefreshColor()
    local parent = ns.BUFPlayer
    local useCustomColor = ns.db.profile.unitFrames.player.powerBar.foreground.useCustomColor
    local usePowerColor = ns.db.profile.unitFrames.player.powerBar.foreground.usePowerColor
    if usePowerColor then
        local powerType, powerToken, rX, gY, bZ = UnitPowerType("player")
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
        if BUFPlayer:IsHooked(parent.manaBar, "SetStatusBarColor") then
            BUFPlayer:Unhook(parent.manaBar, "SetStatusBarColor")
        end
        parent.manaBar:SetStatusBarColor(r, g, b, 1.0)
        BUFPlayer:SecureHook(parent.manaBar, "SetStatusBarColor", function(_, r, g, b, a)
            self:RefreshColor()
        end)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.foreground.customColor)
        parent.manaBar:SetStatusBarColor(r, g, b, a)
    end
end