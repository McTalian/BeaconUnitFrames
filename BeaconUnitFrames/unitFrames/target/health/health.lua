---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health: BUFConfigHandler, BUFStatusBar
local BUFTargetHealth = {
    configPath = "unitFrames.target.healthBar",
}

BUFTargetHealth.optionsTable = {
    type = "group",
    handler = BUFTargetHealth,
    name = HEALTH,
    order = BUFTarget.optionsOrder.HEALTH,
    childGroups = "tree",
    args = {},
}

ns.BUFStatusBar:ApplyMixin(BUFTargetHealth)

BUFTarget.Health = BUFTargetHealth

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = {
    width = 126,
    height = 20,
    anchorPoint = "TOPLEFT",
    relativeTo = "TargetFrame",
    relativePoint = "TOPLEFT",
    xOffset = 148,
    yOffset = 2,
    frameLevel = 3,
}

local healthBarOrder = {}
ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.LEFT_TEXT = healthBarOrder.FRAME_LEVEL + .1
healthBarOrder.RIGHT_TEXT = healthBarOrder.LEFT_TEXT + .1
healthBarOrder.CENTER_TEXT = healthBarOrder.RIGHT_TEXT + .1
healthBarOrder.DEAD_TEXT = healthBarOrder.CENTER_TEXT + .1
healthBarOrder.UNCONSCIOUS_TEXT = healthBarOrder.DEAD_TEXT + .1
healthBarOrder.FOREGROUND = healthBarOrder.UNCONSCIOUS_TEXT + .1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + .1

BUFTargetHealth.topGroupOrder = healthBarOrder

ns.options.args.unitFrames.args.target.args.healthBar = BUFTargetHealth.optionsTable

BUFTargetHealth.coeffs = {
    maskWidth = (128 / ns.dbDefaults.profile.unitFrames.target.healthBar.width),
    maskHeight = (32 / ns.dbDefaults.profile.unitFrames.target.healthBar.height),
    maskXOffset = (-1 / ns.dbDefaults.profile.unitFrames.target.healthBar.width),
    maskYOffset = (6 / ns.dbDefaults.profile.unitFrames.target.healthBar.height),
}

function BUFTargetHealth:RefreshConfig()
    self:InitializeTargetHealth()
    self:RefreshStatusBarConfig()
end

function BUFTargetHealth:InitializeTargetHealth()
    if self.isInitialized then
        return
    end

    self.isInitialized = true
    self.barOrContainer = BUFTarget.healthBar
    self.maskTexture = BUFTarget.healthBarContainer.HealthBarMask
    self.maskTextureAtlas = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Mask"

    self.maskTexture:Hide()
    if not ns.BUFTarget:IsHooked(self.maskTexture, "Show") then
        ns.BUFTarget:SecureHook(self.maskTexture, "Show", function(s)
            s:Hide()
        end)
    end
end
