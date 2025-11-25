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

ns.Mixin(BUFPlayerHealth, ns.Positionable, ns.Sizable, ns.Levelable)

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

local healthBarOrder = {}

ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.LEFT_TEXT = healthBarOrder.FRAME_LEVEL + .1
healthBarOrder.RIGHT_TEXT = healthBarOrder.LEFT_TEXT + .1
healthBarOrder.CENTER_TEXT = healthBarOrder.RIGHT_TEXT + .1
healthBarOrder.FOREGROUND = healthBarOrder.CENTER_TEXT + .1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + .1

BUFPlayerHealth.topGroupOrder = healthBarOrder

local healthBar = {
    type = "group",
    handler = BUFPlayerHealth,
    name = HEALTH,
    order = BUFPlayer.optionsOrder.HEALTH,
    childGroups = "tab",
    args = {},
}

ns.AddSizableOptions(healthBar.args, healthBarOrder)
ns.AddPositionableOptions(healthBar.args, healthBarOrder)
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

    parent.healthBarContainer:SetWidth(width)
    parent.healthBarContainer:SetHeight(height)
    parent.healthBar:SetWidth(width)
    parent.healthBar:SetHeight(height)
    parent.healthBarContainer.HealthBarMask:SetWidth(width * self.coeffs.maskWidth)
    parent.healthBarContainer.HealthBarMask:SetHeight(height * self.coeffs.maskHeight)
    parent.healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset,
        height * self.coeffs.maskYOffset)
end

function BUFPlayerHealth:SetPosition()
    local parent = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.healthBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.yOffset
    if BUFPlayer:IsHooked(parent.healthBarContainer, "SetPoint") then
        BUFPlayer:Unhook(parent.healthBarContainer, "SetPoint")
    end
    parent.healthBarContainer:ClearAllPoints()
    parent.healthBarContainer:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerHealth:SetLevel()
    local parent = BUFPlayer
    local frameLevel = ns.db.profile.unitFrames.player.healthBar.frameLevel
    parent.healthBarContainer:SetUsingParentLevel(false)
    parent.healthBarContainer:SetFrameLevel(frameLevel)
end
