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

ns.Mixin(foregroundHandler, ns.StatusBarTexturable, ns.Colorable, ns.PowerColorable)

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.foreground = {
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useCustomColor = false,
    customColor = { 0, 0, 1, 1 },
    usePowerColor = false,
}

local foreground = {
    type = "group",
    handler = foregroundHandler,
    name = ns.L["Foreground"],
    order = BUFPlayerPower.topGroupOrder.FOREGROUND,
    args = {}
}

ns.AddStatusBarTextureOptions(foreground.args)
ns.AddColorOptions(foreground.args)
ns.AddPowerColorOptions(foreground.args)

ns.options.args.player.args.powerBar.args.foreground = foreground

function foregroundHandler:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        if not BUFPlayer:IsHooked(BUFPlayer.manaBar, "SetStatusBarTexture") then
            BUFPlayer:SecureHook(BUFPlayer.manaBar, "SetStatusBarTexture", function(_, t)
                if t == "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana" and self:GetUseStatusBarTexture() then
                    self:RefreshStatusBarTexture()
                end
            end)
        end

        if not BUFPlayer:IsHooked(BUFPlayer.manaBar, "SetStatusBarColor") then
            BUFPlayer:SecureHook(BUFPlayer.manaBar, "SetStatusBarColor", function(_, r, g, b, a)
                local cR, cG, cB, cA = self:_GetColor()
                if cR and (r ~= cR or g ~= cG or b ~= cB or a ~= cA) then
                    self:RefreshColor()
                end
            end)
        end
    end
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
        parent.manaBar:SetStatusBarTexture(texturePath)
    else
        parent.manaBar:SetStatusBarTexture("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana")
    end
end

function foregroundHandler:_GetColor()
    local r, g, b, a = nil, nil, nil, 1
    local useCustomColor = self:GetUseCustomColor()
    local usePowerColor = self:GetUsePowerColor()
    if usePowerColor then
        local powerType, powerToken, rX, gY, bZ = UnitPowerType("player")
        local info = PowerBarColor[powerToken]
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
        
    elseif useCustomColor then
        r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.foreground.customColor)
    end

    return r, g, b, a
end

function foregroundHandler:RefreshColor()
    BUFPlayer.manaBar:SetStatusBarColor(self:_GetColor())
end
