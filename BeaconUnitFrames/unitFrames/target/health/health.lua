---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health: BUFConfigHandler, Anchorable, Positionable, Sizable, Levelable
local BUFTargetHealth = {
    configPath = "unitFrames.target.healthBar",
}

ns.ApplyMixin(ns.Anchorable, BUFTargetHealth)
ns.ApplyMixin(ns.Positionable, BUFTargetHealth)
ns.ApplyMixin(ns.Sizable, BUFTargetHealth)
ns.ApplyMixin(ns.Levelable, BUFTargetHealth)

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

local healthBarOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    ANCHOR_POINT = 3,
    RELATIVE_TO = 4,
    RELATIVE_POINT = 5,
    X_OFFSET = 6,
    Y_OFFSET = 7,
    FRAME_LEVEL = 8,
    LEFT_TEXT = 9,
    RIGHT_TEXT = 10,
    CENTER_TEXT = 11,
    FOREGROUND = 12,
    BACKGROUND = 13,
}

BUFTargetHealth.topGroupOrder = healthBarOrder

local textOrder = {
    ANCHOR_POINT = 1,
    X_OFFSET = 2,
    Y_OFFSET = 3,
    USE_FONT_OBJECTS = 4,
    FONT_OBJECT = 5,
    FONT_COLOR = 6,
    FONT_FACE = 7,
    FONT_SIZE = 8,
    FONT_FLAGS = 9,
    FONT_SHADOW_COLOR = 10,
    FONT_SHADOW_OFFSET_X = 11,
    FONT_SHADOW_OFFSET_Y = 12,
}

BUFTargetHealth.textOrder = textOrder

local healthBar = {
    type = "group",
    handler = BUFTargetHealth,
    name = HEALTH,
    order = BUFTarget.optionsOrder.HEALTH,
    childGroups = "tab",
    args = {},
}

ns.AddSizingOptions(healthBar.args, healthBarOrder)
ns.AddAnchorOptions(healthBar.args, healthBarOrder)
ns.AddPositioningOptions(healthBar.args, healthBarOrder)
ns.AddFrameLevelOption(healthBar.args, healthBarOrder)

ns.options.args.unitFrames.args.target.args.healthBar = healthBar

BUFTargetHealth.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-1 / ns.dbDefaults.profile.unitFrames.target.healthBar.width),
    maskYOffset = 6 / ns.dbDefaults.profile.unitFrames.target.healthBar.height,
}

function BUFTargetHealth:RefreshConfig()
    self:InitializeTargetHealth()
    self:SetPosition()
    self:SetSize()
    self:SetLevel()
    self.leftTextHandler:RefreshConfig()
    self.rightTextHandler:RefreshConfig()
    self.centerTextHandler:RefreshConfig()
    self.foregroundHandler:RefreshConfig()
end

function BUFTargetHealth:InitializeTargetHealth()
    if self.isInitialized then
        return
    end

    self.isInitialized = true

    local parent = BUFTarget
    parent.healthBarContainer.HealthBarMask:Hide()
    if not ns.BUFTarget:IsHooked(parent.healthBarContainer.HealthBarMask, "Show") then
        ns.BUFTarget:RawHook(parent.healthBarContainer.HealthBarMask, "Show", ns.noop, true)
    end
end

function BUFTargetHealth:SetSize()
    local parent = BUFTarget
    local width = ns.db.profile.unitFrames.target.healthBar.width
    local height = ns.db.profile.unitFrames.target.healthBar.height
    PixelUtil.SetWidth(parent.healthBar, width, 18)
    PixelUtil.SetHeight(parent.healthBar, height, 18)
    PixelUtil.SetWidth(parent.healthBarContainer.HealthBarMask, width * self.coeffs.maskWidth, 18)
    PixelUtil.SetHeight(parent.healthBarContainer.HealthBarMask, height * self.coeffs.maskHeight, 18)
    parent.healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset,
        height * self.coeffs.maskYOffset)
end

function BUFTargetHealth:SetPosition()
    local parent = BUFTarget
    local xOffset = ns.db.profile.unitFrames.target.healthBar.xOffset
    local yOffset = ns.db.profile.unitFrames.target.healthBar.yOffset
    parent.healthBar:ClearAllPoints()
    parent.healthBar:SetPoint(
        ns.db.profile.unitFrames.target.healthBar.anchorPoint,
        _G[ns.db.profile.unitFrames.target.healthBar.relativeTo],
        ns.db.profile.unitFrames.target.healthBar.relativePoint,
        xOffset,
        yOffset)
end

function BUFTargetHealth:SetLevel()
    local parent = BUFTarget
    local frameLevel = ns.db.profile.unitFrames.target.healthBar.frameLevel
    parent.healthBar:SetUsingParentLevel(false)
    parent.healthBar:SetFrameLevel(frameLevel)
end
