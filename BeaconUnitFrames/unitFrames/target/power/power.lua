---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power: BUFConfigHandler, BUFStatusBar
local BUFTargetPower = {
    configPath = "unitFrames.target.powerBar",
}

BUFTargetPower.optionsTable = {
    type = "group",
    handler = BUFTargetPower,
    name = POWER_TYPE_POWER,
    order = BUFTarget.optionsOrder.POWER,
    childGroups = "tree",
    args = {},
}

---@class BUFDbSchema.UF.Target.Power
BUFTargetPower.dbDefaults = {
    width = 134,
    height = 10,
    anchorPoint = "TOPRIGHT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 8,
    yOffset = -1,
    frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFTargetPower)

BUFTarget.Power = BUFTargetPower

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target


ns.dbDefaults.profile.unitFrames.target.powerBar = BUFTargetPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + .1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + .1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + .1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + .1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + .1

BUFTargetPower.topGroupOrder = powerBarOrder

ns.options.args.target.args.powerBar = BUFTargetPower.optionsTable

BUFTargetPower.coeffs = {
    maskWidth = (256 / ns.dbDefaults.profile.unitFrames.target.powerBar.width),
    maskHeight = (16 / ns.dbDefaults.profile.unitFrames.target.powerBar.height),
    maskXOffset = (-61 / ns.dbDefaults.profile.unitFrames.target.powerBar.width),
    maskYOffset = (3 / ns.dbDefaults.profile.unitFrames.target.powerBar.height),
}

function BUFTargetPower:RefreshConfig()
    self:InitializeTargetPower()
    self:RefreshStatusBarConfig()
    -- self:SetPosition()
    -- self:SetSize()
    -- self:SetLevel()
    -- self.leftTextHandler:RefreshConfig()
    -- self.rightTextHandler:RefreshConfig()
    -- self.centerTextHandler:RefreshConfig()
    -- self.foregroundHandler:RefreshConfig()
    -- self.backgroundHandler:RefreshConfig()
end

function BUFTargetPower:InitializeTargetPower()
    if self.isInitialized then
        return
    end

    self.isInitialized = true

    self.barOrContainer = BUFTarget.manaBar
    self.maskTexture = BUFTarget.manaBar.ManaBarMask
    self.maskTextureAtlas = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Mask"
    self.defaultRelativeTo = BUFTarget.healthBar
    self.defaultRelativePoint = "BOTTOMRIGHT"

    local parent = BUFTarget
    parent.manaBar.ManaBarMask:Hide()
end
