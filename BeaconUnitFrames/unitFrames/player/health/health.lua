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
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
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
    childGroups = "tree",
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
    if not self.initialized then
        self.initialized = true
        self.defaultRelativeTo = "PlayerFrame"
        self.defaultRelativePoint = "TOPLEFT"
        if not BUFPlayer:IsHooked(BUFPlayer.healthBarContainer.HealthBarMask, "SetPoint") then
            BUFPlayer:SecureHook(BUFPlayer.healthBarContainer.HealthBarMask, "SetPoint", function()
                BUFPlayerHealth:SetUnprotectedSize()
            end)
        end

        if not BUFPlayer:IsHooked(BUFPlayer.healthBarContainer.HealthBarMask, "SetHeight") then
            BUFPlayer:SecureHook(BUFPlayer.healthBarContainer.HealthBarMask, "SetHeight", function()
                BUFPlayerHealth:SetUnprotectedSize()
            end)
        end
    end
    if not InCombatLockdown() then
        self:SetPosition()
        self:SetSize()
        self:SetLevel()
    else
        self:SetUnprotectedSize()
    end
    self.leftTextHandler:RefreshConfig()
    self.rightTextHandler:RefreshConfig()
    self.centerTextHandler:RefreshConfig()
    self.foregroundHandler:RefreshConfig()
    self.backgroundHandler:RefreshConfig()
end

function BUFPlayerHealth:SetUnprotectedSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.healthBar.width
    local height = ns.db.profile.unitFrames.player.healthBar.height

    parent.healthBarContainer.HealthBarMask:SetWidth(width * self.coeffs.maskWidth)
    if BUFPlayer:IsHooked(parent.healthBarContainer.HealthBarMask, "SetHeight") then
        BUFPlayer:Unhook(parent.healthBarContainer.HealthBarMask, "SetHeight")
    end
    parent.healthBarContainer.HealthBarMask:SetHeight(height * self.coeffs.maskHeight)
    if not BUFPlayer:IsHooked(parent.healthBarContainer.HealthBarMask, "SetHeight") then
        BUFPlayer:SecureHook(parent.healthBarContainer.HealthBarMask, "SetHeight", function()
            BUFPlayerHealth:SetUnprotectedSize()
        end)
    end
    if BUFPlayer:IsHooked(parent.healthBarContainer.HealthBarMask, "SetPoint") then
        BUFPlayer:Unhook(parent.healthBarContainer.HealthBarMask, "SetPoint")
    end
    parent.healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset,
        height * self.coeffs.maskYOffset)
    if not BUFPlayer:IsHooked(parent.healthBarContainer.HealthBarMask, "SetPoint") then
        BUFPlayer:SecureHook(parent.healthBarContainer.HealthBarMask, "SetPoint", function()
            BUFPlayerHealth:SetUnprotectedSize()
        end)
    end
end

function BUFPlayerHealth:SetSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.healthBar.width
    local height = ns.db.profile.unitFrames.player.healthBar.height

    parent.healthBarContainer:SetWidth(width)
    parent.healthBarContainer:SetHeight(height)
    parent.healthBar:SetWidth(width)
    parent.healthBar:SetHeight(height)
    self:SetUnprotectedSize()

    parent.healthBarContainer:SetAttribute("buf_restore_size", format([[
        self:SetWidth(%d);
        self:SetHeight(%d);
    ]], width, height))
    parent.healthBar:SetAttribute("buf_restore_size", format([[
        self:SetWidth(%d);
        self:SetHeight(%d);
    ]], width, height))
end

function BUFPlayerHealth:SetPosition()
    local parent = BUFPlayer
    local anchorPoint = self:GetAnchorPoint() or "TOPLEFT"
    ---@type string
    local relativeTo = self:GetRelativeTo() or ns.DEFAULT
    if relativeTo == ns.DEFAULT then
        relativeTo = self.defaultRelativeTo or "UIParent"
    end

    ---@type string
    local relativePoint = self:GetRelativePoint() or ns.DEFAULT
    if relativePoint == ns.DEFAULT then
        relativePoint = self.defaultRelativePoint or "TOPLEFT"
    end
    local xOffset = ns.db.profile.unitFrames.player.healthBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.yOffset

    self:_SetPosition(parent.healthBarContainer)

    parent.healthBarContainer:SetAttribute("buf_restore_position", format([[
        local anchorPoint = "%s"
        local relativeTo = self:GetParent()
        local relativePoint = "%s"
        local xOffset = %d
        local yOffset = %d
        self:ClearAllPoints();
        self:SetPoint(anchorPoint, relativeTo, relativePoint, xOffset, yOffset);
    ]], anchorPoint, relativePoint, xOffset, yOffset))
end

function BUFPlayerHealth:SetLevel()
    local parent = BUFPlayer
    local frameLevel = ns.db.profile.unitFrames.player.healthBar.frameLevel
    parent.healthBarContainer:SetUsingParentLevel(false)
    parent.healthBarContainer:SetFrameLevel(frameLevel)
end
