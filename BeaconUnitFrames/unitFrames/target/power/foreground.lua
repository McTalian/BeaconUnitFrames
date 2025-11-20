---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.Foreground: BUFConfigHandler, StatusBarTexturable, Colorable, PowerColorable
local foregroundHandler = {
    configPath = "unitFrames.target.powerBar.foreground",
}

BUFTargetPower.foregroundHandler = foregroundHandler

ns.ApplyMixin(ns.StatusBarTexturable, foregroundHandler)
ns.ApplyMixin(ns.Colorable, foregroundHandler)
ns.ApplyMixin(ns.PowerColorable, foregroundHandler)

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.foreground = {
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
    order = BUFTargetPower.topGroupOrder.FOREGROUND,
    args = {}
}

ns.AddStatusBarTextureOptions(foreground.args, foregroundOrder)
ns.AddColorOptions(foreground.args, foregroundOrder)
ns.AddPowerColorOptions(foreground.args, foregroundOrder)

ns.options.args.unitFrames.args.target.args.powerBar.args.foreground = foreground

function foregroundHandler:RefreshConfig()
    self:RefreshStatusBarTexture()
    self:RefreshColor()
end

function foregroundHandler:RefreshStatusBarTexture()
    local parent = ns.BUFTarget
    local useCustomTexture = ns.db.profile.unitFrames.target.powerBar.foreground.useStatusBarTexture
    if useCustomTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR,
            ns.db.profile.unitFrames.target.powerBar.foreground.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.manaBar:SetStatusBarTexture(texturePath)
        BUFTargetPower:SetLevel()
    else
        parent.manaBar:SetStatusBarTexture("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana")
    end
end

function foregroundHandler:RefreshColor()
    local parent = ns.BUFTarget
    local useCustomColor = ns.db.profile.unitFrames.target.powerBar.foreground.useCustomColor
    local usePowerColor = ns.db.profile.unitFrames.target.powerBar.foreground.usePowerColor
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
        parent.manaBar:SetStatusBarColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.foreground.customColor)
        parent.manaBar:SetStatusBarColor(r, g, b, a)
    end
end