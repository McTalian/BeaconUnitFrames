---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.Foreground: StatusBarForeground
local foregroundHandler = {
    configPath = "unitFrames.player.powerBar.foreground",
}

foregroundHandler.optionsTable = {
    type = "group",
    handler = foregroundHandler,
    name = ns.L["Foreground"],
    order = BUFPlayerPower.topGroupOrder.FOREGROUND,
    args = {}
}

---@class BUFDbSchema.UF.Player.Power.Foreground
foregroundHandler.dbDefaults = {
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useCustomColor = false,
    customColor = { 0, 0, 1, 1 },
    usePowerColor = false,
}

BUFPlayerPower.foregroundHandler = foregroundHandler

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.foreground = foregroundHandler.dbDefaults

ns.options.args.player.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        self.unit = "player"
        self.statusBar = BUFPlayer.manaBar
        self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana"

        if not BUFPlayer:IsHooked(BUFPlayer.manaBar, "SetStatusBarTexture") then
            BUFPlayer:SecureHook(BUFPlayer.manaBar, "SetStatusBarTexture", function(_, t)
                if t == self.defaultStatusBarTexture and self:GetUseStatusBarTexture() then
                    self:RefreshStatusBarTexture()
                end
            end)
        end

        if not BUFPlayer:IsHooked(BUFPlayer.manaBar, "SetStatusBarColor") then
            BUFPlayer:SecureHook(BUFPlayer.manaBar, "SetStatusBarColor", function(_, r, g, b, a)
                local cR, cG, cB, cA = self:_GetOptionsBasedColor()
                if cR and (r ~= cR or g ~= cG or b ~= cB or a ~= cA) then
                    self:RefreshColor()
                end
            end)
        end
    end
    self:RefreshStatusBarForegroundConfig()
end
