---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power: BUFConfigHandler, Positionable, Sizable, Levelable
local BUFPlayerPower = {
    configPath = "unitFrames.player.powerBar",
}

ns.Mixin(BUFPlayerPower, ns.Positionable, ns.Sizable, ns.Levelable)

BUFPlayer.Power = BUFPlayerPower

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = {
    width = 124,
    height = 10,
    xOffset = 85,
    yOffset = -61,
    frameLevel = 3,
}

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + .1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + .1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + .1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + .1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + .1

BUFPlayerPower.topGroupOrder = powerBarOrder

local powerBar = {
    type = "group",
    handler = BUFPlayerPower,
    name = POWER_TYPE_POWER,
    order = BUFPlayer.optionsOrder.POWER,
    childGroups = "tab",
    args = {},
}

ns.AddSizableOptions(powerBar.args, powerBarOrder)
ns.AddPositionableOptions(powerBar.args, powerBarOrder)
ns.AddFrameLevelOption(powerBar.args, powerBarOrder)

ns.options.args.unitFrames.args.player.args.powerBar = powerBar

BUFPlayerPower.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.dbDefaults.profile.unitFrames.player.powerBar.width),
    maskYOffset = 2 / ns.dbDefaults.profile.unitFrames.player.powerBar.height,
}

function BUFPlayerPower:RefreshConfig()
    self:SetPosition()
    self:SetSize()
    self:SetLevel()
    self.leftTextHandler:RefreshConfig()
    self.rightTextHandler:RefreshConfig()
    self.centerTextHandler:RefreshConfig()
    self.foregroundHandler:RefreshConfig()
    -- self.backgroundHandler:RefreshConfig()
end

function BUFPlayerPower:SetSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.powerBar.width
    local height = ns.db.profile.unitFrames.player.powerBar.height
    PixelUtil.SetWidth(parent.manaBar, width, 18)
    PixelUtil.SetHeight(parent.manaBar, height, 18)
    PixelUtil.SetWidth(parent.manaBar.FullPowerFrame, width, 18)
    PixelUtil.SetHeight(parent.manaBar.FullPowerFrame, height, 18)
    PixelUtil.SetWidth(parent.manaBar.FullPowerFrame.SpikeFrame, width, 18)
    PixelUtil.SetHeight(parent.manaBar.FullPowerFrame.SpikeFrame, height, 18)
    PixelUtil.SetWidth(parent.manaBar.FullPowerFrame.PulseFrame, width, 18)
    PixelUtil.SetHeight(parent.manaBar.FullPowerFrame.PulseFrame, height, 18)
    PixelUtil.SetWidth(parent.manaBar.ManaBarMask, width * self.coeffs.maskWidth, 18)
    PixelUtil.SetHeight(parent.manaBar.ManaBarMask, height * self.coeffs.maskHeight, 18)
    parent.manaBar.ManaBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset, height * self.coeffs.maskYOffset)
end

function BUFPlayerPower:SetPosition()
    local parent = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.powerBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.powerBar.yOffset
    parent.manaBar:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerPower:SetLevel()
    local parent = BUFPlayer
    local frameLevel = ns.db.profile.unitFrames.player.powerBar.frameLevel
    parent.manaBar:SetUsingParentLevel(false)
    parent.manaBar:SetFrameLevel(frameLevel)
end