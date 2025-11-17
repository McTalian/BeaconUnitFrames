---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = {}

BUFPlayer.Health = BUFPlayerHealth

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = {
    width = 124,
    height = 20,
    xOffset = 85,
    yOffset = -40,
    frameLevel = 3,
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useBackgroundTexture = false,
    backgroundTexture = "",
    useCustomColor = false,
    customColor = { 0, 1, 0, 1 },
    useClassColor = false,
}

local healthBarOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    X_OFFSET = 3,
    Y_OFFSET = 4,
    FRAME_LEVEL = 5,
    FOREGROUND = 6,
    BACKGROUND = 7,
}

local foregroundOrder = {
    USE_STATUS_BAR_TEXTURE = 1,
    STATUS_BAR_TEXTURE = 2,
    USE_CUSTOM_COLOR = 3,
    CUSTOM_COLOR = 4,
    CLASS_COLOR = 5,
}

local backgroundOrder = {
    USE_BACKGROUND_TEXTURE = 1,
    BACKGROUND_TEXTURE = 2,
    USE_CUSTOM_COLOR = 3,
    CUSTOM_COLOR = 4,
    CLASS_COLOR = 5,
}

local healthBar = {
    type = "group",
    handler = BUFPlayerHealth,
    name = HEALTH,
    order = BUFPlayer.optionsOrder.HEALTH,
    inline = true,
    args = {
        foreground = {
            type = "group",
            name = ns.L["Foreground"],
            inline = true,
            order = healthBarOrder.FOREGROUND,
            args = {}
        },
        background = {
            type = "group",
            handler = BUFPlayerHealth,
            name = BACKGROUND,
            inline = true,
            order = healthBarOrder.BACKGROUND,
            args = {}
        },
    },
}

ns.AddSizingOptions(healthBar.args, healthBarOrder)
ns.AddPositioningOptions(healthBar.args, healthBarOrder)
ns.AddFrameLevelOption(healthBar.args, healthBarOrder)

ns.AddStatusBarForegroundOptions(healthBar.args.foreground.args, foregroundOrder)

ns.AddBackgroundTextureOptions(healthBar.args.background.args, backgroundOrder)

ns.options.args.unitFrames.args.player.args.healthBar = healthBar

-- Handler methods for health bar options
function BUFPlayerHealth:SetWidth(info, value)
    ns.db.profile.unitFrames.player.healthBar.width = value
    BUFPlayerHealth:SetHealthSize()
end

function BUFPlayerHealth:GetWidth(info)
    return ns.db.profile.unitFrames.player.healthBar.width
end

function BUFPlayerHealth:SetHeight(info, value)
    ns.db.profile.unitFrames.player.healthBar.height = value
    BUFPlayerHealth:SetHealthSize()
end

function BUFPlayerHealth:GetHeight(info)
    return ns.db.profile.unitFrames.player.healthBar.height
end

function BUFPlayerHealth:SetXOffset(info, value)
    ns.db.profile.unitFrames.player.healthBar.xOffset = value
    BUFPlayerHealth:SetHealthPosition()
end

function BUFPlayerHealth:GetXOffset(info)
    return ns.db.profile.unitFrames.player.healthBar.xOffset
end

function BUFPlayerHealth:SetYOffset(info, value)
    ns.db.profile.unitFrames.player.healthBar.yOffset = value
    BUFPlayerHealth:SetHealthPosition()
end

function BUFPlayerHealth:GetYOffset(info)
    return ns.db.profile.unitFrames.player.healthBar.yOffset
end

function BUFPlayerHealth:SetFrameLevel(info, value)
    ns.db.profile.unitFrames.player.healthBar.frameLevel = value
    BUFPlayerHealth:SetHealthBarLevel()
end

function BUFPlayerHealth:GetFrameLevel(info)
    return ns.db.profile.unitFrames.player.healthBar.frameLevel
end

-- Foreground options
function BUFPlayerHealth:SetUseStatusBarTexture(info, value)
    ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture = value
    BUFPlayerHealth:SetHealthStatusBarTexture()
end

function BUFPlayerHealth:GetUseStatusBarTexture(info)
    return ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture
end

function BUFPlayerHealth:SetStatusBarTexture(info, value)
    ns.db.profile.unitFrames.player.healthBar.statusBarTexture = value
    BUFPlayerHealth:SetHealthStatusBarTexture()
end

function BUFPlayerHealth:GetStatusBarTexture(info)
    return ns.db.profile.unitFrames.player.healthBar.statusBarTexture
end

function BUFPlayerHealth:SetUseCustomColor(info, value)
    ns.db.profile.unitFrames.player.healthBar.useCustomColor = value
    BUFPlayerHealth:SetHealthColor()
end

function BUFPlayerHealth:GetUseCustomColor(info)
    return ns.db.profile.unitFrames.player.healthBar.useCustomColor
end

function BUFPlayerHealth:SetCustomColor(info, r, g, b, a)
    ns.db.profile.unitFrames.player.healthBar.customColor = { r, g, b, a }
    BUFPlayerHealth:SetHealthColor()
end

function BUFPlayerHealth:GetCustomColor(info)
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.customColor)
    return r, g, b, a
end

function BUFPlayerHealth:SetUseClassColor(info, value)
    ns.db.profile.unitFrames.player.healthBar.useClassColor = value
    BUFPlayerHealth:SetHealthColor()
end

function BUFPlayerHealth:GetUseClassColor(info)
    return ns.db.profile.unitFrames.player.healthBar.useClassColor
end

-- Background options
function BUFPlayerHealth:SetUseBackgroundTexture(info, value)
    ns.db.profile.unitFrames.player.healthBar.useBackgroundTexture = value
    BUFPlayerHealth:SetHealthBarBackgroundTexture()
end

function BUFPlayerHealth:GetUseBackgroundTexture(info)
    return ns.db.profile.unitFrames.player.healthBar.useBackgroundTexture
end

function BUFPlayerHealth:SetBackgroundTexture(info, value)
    ns.db.profile.unitFrames.player.healthBar.backgroundTexture = value
    BUFPlayerHealth:SetHealthBarBackgroundTexture()
end

function BUFPlayerHealth:GetBackgroundTexture(info)
    return ns.db.profile.unitFrames.player.healthBar.backgroundTexture
end

-- Disabled functions
function BUFPlayerHealth:IsStatusBarTextureDisabled(info)
    return ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture == false
end

function BUFPlayerHealth:IsCustomColorDisabled(info)
    return ns.db.profile.unitFrames.player.healthBar.useCustomColor == false
end

function BUFPlayerHealth:IsBackgroundTextureDisabled(info)
    return ns.db.profile.unitFrames.player.healthBar.useBackgroundTexture == false
end

BUFPlayerHealth.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.dbDefaults.profile.unitFrames.player.healthBar.width),
    maskYOffset = 6 / ns.dbDefaults.profile.unitFrames.player.healthBar.height,
}

function BUFPlayerHealth:RefreshConfig()
    self:SetHealthPosition()
    self:SetHealthSize()
    self:SetHealthStatusBarTexture()
    self:SetHealthBarLevel()
    self:SetHealthColor()
    self:SetHealthBarBackgroundTexture()
end

function BUFPlayerHealth:SetHealthSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.healthBar.width
    local height = ns.db.profile.unitFrames.player.healthBar.height
    PixelUtil.SetWidth(parent.healthBarContainer, width, 18)
    PixelUtil.SetHeight(parent.healthBarContainer, height, 18)
    PixelUtil.SetWidth(parent.healthBar, width, 18)
    PixelUtil.SetHeight(parent.healthBar, height, 18)
    PixelUtil.SetWidth(parent.healthBarContainer.HealthBarMask, width * self.coeffs.maskWidth, 18)
    PixelUtil.SetHeight(parent.healthBarContainer.HealthBarMask, height * self.coeffs.maskHeight, 18)
    parent.healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset, 6 * self.coeffs.maskYOffset)
end

function BUFPlayerHealth:SetHealthPosition()
    local parent = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.healthBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.yOffset
    parent.healthBarContainer:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerHealth:SetHealthBarLevel()
    local parent = BUFPlayer
    local frameLevel = ns.db.profile.unitFrames.player.healthBar.frameLevel
    parent.healthBar:SetFrameLevel(frameLevel)
end

function BUFPlayerHealth:SetHealthStatusBarTexture()
    local parent = BUFPlayer
    local useCustomTexture = ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture
    if useCustomTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, ns.db.profile.unitFrames.player.healthBar.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.healthBar:SetStatusBarTexture(texturePath)
        self:SetHealthBarLevel()
    end
end

function BUFPlayerHealth:SetHealthColor()
    local parent = BUFPlayer
    local useCustomColor = ns.db.profile.unitFrames.player.healthBar.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.player.healthBar.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.healthBar:SetStatusBarColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.customColor)
        parent.healthBar:SetStatusBarColor(r, g, b, a)
    end
end

function BUFPlayerHealth:SetHealthBarBackgroundTexture()
    local parent = BUFPlayer
    local useBackgroundTexture = ns.db.profile.unitFrames.player.healthBar.useBackgroundTexture
    if useBackgroundTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, ns.db.profile.unitFrames.player.healthBar.backgroundTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, "Solid") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.healthBar.Background:SetTexture(texturePath)
        parent.healthBar.Background:Show()
    end
end
