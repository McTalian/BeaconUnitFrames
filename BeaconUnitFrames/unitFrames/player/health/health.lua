---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health: BUFConfigHandler, Positionable, Sizable, Levelable
local BUFPlayerHealth = {
    configPath = "unitFrames.player.healthBar",
}


ns.ApplyMixin(ns.Positionable, BUFPlayerHealth)
ns.ApplyMixin(ns.Sizable, BUFPlayerHealth)
ns.ApplyMixin(ns.Levelable, BUFPlayerHealth)

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
}

local healthBarOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    X_OFFSET = 3,
    Y_OFFSET = 4,
    FRAME_LEVEL = 5,
    LEFT_TEXT = 6,
    RIGHT_TEXT = 7,
    CENTER_TEXT = 8,
    FOREGROUND = 9,
    BACKGROUND = 10,
}

BUFPlayerHealth.topGroupOrder = healthBarOrder

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

BUFPlayerHealth.textOrder = textOrder

local healthBar = {
    type = "group",
    handler = BUFPlayerHealth,
    name = HEALTH,
    order = BUFPlayer.optionsOrder.HEALTH,
    childGroups = "tab",
    args = {},
}

ns.AddSizingOptions(healthBar.args, healthBarOrder)
ns.AddPositioningOptions(healthBar.args, healthBarOrder)
ns.AddFrameLevelOption(healthBar.args, healthBarOrder)

ns.options.args.unitFrames.args.player.args.healthBar = healthBar

BUFPlayerHealth.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.dbDefaults.profile.unitFrames.player.healthBar.width),
    maskYOffset = 6 / ns.dbDefaults.profile.unitFrames.player.healthBar.height,
}

function BUFPlayerHealth:RefreshConfig()
    self:SetPosition()
    self:SetSize()
    self:SetLevel()
    self.leftTextHandler:RefreshConfig()
    self.rightTextHandler:RefreshConfig()
    self.centerTextHandler:RefreshConfig()
    self.foregroundHandler:RefreshConfig()
    self.backgroundHandler:RefreshConfig()
end

function BUFPlayerHealth:SetSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.healthBar.width
    local height = ns.db.profile.unitFrames.player.healthBar.height
    PixelUtil.SetWidth(parent.healthBarContainer, width, 18)
    PixelUtil.SetHeight(parent.healthBarContainer, height, 18)
    PixelUtil.SetWidth(parent.healthBar, width, 18)
    PixelUtil.SetHeight(parent.healthBar, height, 18)
    PixelUtil.SetWidth(parent.healthBarContainer.HealthBarMask, width * self.coeffs.maskWidth, 18)
    PixelUtil.SetHeight(parent.healthBarContainer.HealthBarMask, height * self.coeffs.maskHeight, 18)
    parent.healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset,
        height * self.coeffs.maskYOffset)
end

function BUFPlayerHealth:SetPosition()
    local parent = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.healthBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.yOffset
    parent.healthBarContainer:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerHealth:SetLevel()
    local parent = BUFPlayer
    local frameLevel = ns.db.profile.unitFrames.player.healthBar.frameLevel
    parent.healthBarContainer:SetUsingParentLevel(false)
    parent.healthBarContainer:SetFrameLevel(frameLevel)
end
