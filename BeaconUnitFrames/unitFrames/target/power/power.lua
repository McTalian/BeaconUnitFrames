---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power: BUFConfigHandler, Positionable, Sizable, Levelable
local BUFTargetPower = {
    configPath = "unitFrames.target.powerBar",
}

ns.ApplyMixin(ns.Positionable, BUFTargetPower)
ns.ApplyMixin(ns.Sizable, BUFTargetPower)
ns.ApplyMixin(ns.Levelable, BUFTargetPower)

BUFTarget.Power = BUFTargetPower

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = {
    width = 134,
    height = 10,
    xOffset = 8,
    yOffset = -1,
    frameLevel = 3,
}

local powerBarOrder = {
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

BUFTargetPower.topGroupOrder = powerBarOrder

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

BUFTargetPower.textOrder = textOrder

local powerBar = {
    type = "group",
    handler = BUFTargetPower,
    name = POWER_TYPE_POWER,
    order = BUFTarget.optionsOrder.POWER,
    childGroups = "tab",
    args = {},
}

ns.AddSizableOptions(powerBar.args, powerBarOrder)
ns.AddPositionableOptions(powerBar.args, powerBarOrder)
ns.AddFrameLevelOption(powerBar.args, powerBarOrder)

ns.options.args.unitFrames.args.target.args.powerBar = powerBar

BUFTargetPower.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-61 / ns.dbDefaults.profile.unitFrames.target.powerBar.width),
    maskYOffset = 3 / ns.dbDefaults.profile.unitFrames.target.powerBar.height,
}

function BUFTargetPower:RefreshConfig()
    self:SetPosition()
    self:SetSize()
    self:SetLevel()
    self.leftTextHandler:RefreshConfig()
    self.rightTextHandler:RefreshConfig()
    self.centerTextHandler:RefreshConfig()
    self.foregroundHandler:RefreshConfig()
    -- self.backgroundHandler:RefreshConfig()
end

function BUFTargetPower:SetSize()
    local parent = BUFTarget
    local width = ns.db.profile.unitFrames.target.powerBar.width
    local height = ns.db.profile.unitFrames.target.powerBar.height
    PixelUtil.SetWidth(parent.manaBar, width, 18)
    PixelUtil.SetHeight(parent.manaBar, height, 18)
    PixelUtil.SetWidth(parent.manaBar.ManaBarMask, width * self.coeffs.maskWidth, 18)
    PixelUtil.SetHeight(parent.manaBar.ManaBarMask, height * self.coeffs.maskHeight, 18)
    parent.manaBar.ManaBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset, height * self.coeffs.maskYOffset)
end

function BUFTargetPower:SetPosition()
    local parent = BUFTarget
    local xOffset = ns.db.profile.unitFrames.target.powerBar.xOffset
    local yOffset = ns.db.profile.unitFrames.target.powerBar.yOffset
    parent.manaBar:SetPoint("TOPRIGHT", ns.BUFTarget.healthBarContainer, "BOTTOMRIGHT", xOffset, yOffset)
end

function BUFTargetPower:SetLevel()
    local parent = BUFTarget
    local frameLevel = ns.db.profile.unitFrames.target.powerBar.frameLevel
    parent.manaBar:SetUsingParentLevel(false)
    parent.manaBar:SetFrameLevel(frameLevel)
end