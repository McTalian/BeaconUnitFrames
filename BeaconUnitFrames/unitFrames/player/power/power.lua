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
    childGroups = "tree",
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
    if not self.initialized then
        self.initialized = true

        if not BUFPlayer:IsHooked(BUFPlayer.manaBar.ManaBarMask, "SetWidth") then
            BUFPlayer:SecureHook(BUFPlayer.manaBar.ManaBarMask, "SetWidth", function()
                BUFPlayerPower:SetUnprotectedSize()
            end)
        end

        if not BUFPlayer:IsHooked(BUFPlayer.manaBar.ManaBarMask, "SetAtlas") then
            BUFPlayer:SecureHook(BUFPlayer.manaBar.ManaBarMask, "SetAtlas", function()
                BUFPlayerPower:SetUnprotectedSize()
            end)
        end
    end
    self:SetPosition()
    self:SetSize()
    self:SetLevel()
    self.leftTextHandler:RefreshConfig()
    self.rightTextHandler:RefreshConfig()
    self.centerTextHandler:RefreshConfig()
    self.foregroundHandler:RefreshConfig()
    -- self.backgroundHandler:RefreshConfig()
end

function BUFPlayerPower:SetUnprotectedSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.powerBar.width
    local height = ns.db.profile.unitFrames.player.powerBar.height
    parent.manaBar.FullPowerFrame:SetWidth(width)
    parent.manaBar.FullPowerFrame:SetHeight(height)
    parent.manaBar.FullPowerFrame.SpikeFrame:SetWidth(width)
    parent.manaBar.FullPowerFrame.SpikeFrame:SetHeight(height)
    parent.manaBar.FullPowerFrame.PulseFrame:SetWidth(width)
    parent.manaBar.FullPowerFrame.PulseFrame:SetHeight(height)
    if BUFPlayer:IsHooked(parent.manaBar.ManaBarMask, "SetWidth") then
        BUFPlayer:Unhook(parent.manaBar.ManaBarMask, "SetWidth")
    end
    parent.manaBar.ManaBarMask:SetWidth(width * self.coeffs.maskWidth)
    if not BUFPlayer:IsHooked(parent.manaBar.ManaBarMask, "SetWidth") then
        BUFPlayer:SecureHook(parent.manaBar.ManaBarMask, "SetWidth", function()
            BUFPlayerPower:SetUnprotectedSize()
        end)
    end
    parent.manaBar.ManaBarMask:SetHeight(height * self.coeffs.maskHeight)
    parent.manaBar.ManaBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset, height * self.coeffs.maskYOffset)
end

function BUFPlayerPower:SetSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.powerBar.width
    local height = ns.db.profile.unitFrames.player.powerBar.height
    parent.manaBar:SetWidth(width)
    parent.manaBar:SetHeight(height)
    self:SetUnprotectedSize()

    parent.manaBar:SetAttribute("buf_restore_size", format([[
        local width, height = %d, %d;
        self:SetWidth(width);
        self:SetHeight(height);
    ]], width, height))
end

function BUFPlayerPower:SetPosition()
    local parent = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.powerBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.powerBar.yOffset
    parent.manaBar:SetPoint("TOPLEFT", xOffset, yOffset)

    parent.manaBar:SetAttribute("buf_restore_position", format([[
        local xOffset, yOffset = %d, %d;
        self:ClearAllPoints();
        self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", xOffset, yOffset);
    ]], xOffset, yOffset))
end

function BUFPlayerPower:SetLevel()
    local parent = BUFPlayer
    local frameLevel = ns.db.profile.unitFrames.player.powerBar.frameLevel
    parent.manaBar:SetUsingParentLevel(false)
    parent.manaBar:SetFrameLevel(frameLevel)
end