---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power: BUFConfigHandler, BUFStatusBar
local BUFPlayerPower = {
    configPath = "unitFrames.player.powerBar",
}

BUFPlayerPower.optionsTable = {
    type = "group",
    handler = BUFPlayerPower,
    name = POWER_TYPE_POWER,
    order = BUFPlayer.optionsOrder.POWER,
    childGroups = "tree",
    args = {},
}

---@class BUFDbSchema.UF.Player.Power
BUFPlayerPower.dbDefaults = {
    width = 124,
    height = 10,
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = "TOPLEFT",
    xOffset = 85,
    yOffset = -61,
    frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFPlayerPower)

BUFPlayer.Power = BUFPlayerPower

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

ns.dbDefaults.profile.unitFrames.player.powerBar = BUFPlayerPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + .1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + .1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + .1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + .1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + .1

BUFPlayerPower.topGroupOrder = powerBarOrder

ns.options.args.player.args.powerBar = BUFPlayerPower.optionsTable

BUFPlayerPower.coeffs = {
    maskWidth = (128 / BUFPlayerPower.dbDefaults.width) + 1.0,
    maskHeight = (16 / BUFPlayerPower.dbDefaults.height),
    maskXOffset = (-2 / BUFPlayerPower.dbDefaults.width),
    maskYOffset = 2 / BUFPlayerPower.dbDefaults.height,
}

function BUFPlayerPower:RefreshConfig()
    if not self.initialized then
        self.initialized = true
        self.defaultRelativeTo = BUFPlayer.contentMain

        self.barOrContainer = BUFPlayer.manaBar
        self.maskTexture = BUFPlayer.manaBar.ManaBarMask
        self.maskTextureAtlas = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Mask"
        self.positionMask = false
    end
    self:RefreshStatusBarConfig()
end

function BUFPlayerPower:SetUnprotectedSize()
    local manaBar = BUFPlayer.manaBar
    self:_SetSize(manaBar.FullPowerFrame)
    self:_SetSize(manaBar.FullPowerFrame.SpikeFrame)
    self:_SetSize(manaBar.FullPowerFrame.PulseFrame)
    self:_SetMaskSize()
end

function BUFPlayerPower:SetSize()
    self:_SetSize(self.barOrContainer)
    self:_SetMaskSize()
    self:SetUnprotectedSize()

    local width, height = self:GetWidth(), self:GetHeight()

    BUFPlayer.manaBar:SetAttribute("buf_restore_size", format([[
        local width, height = %d, %d;
        self:SetWidth(width);
        self:SetHeight(height);
    ]], width, height))
end

function BUFPlayerPower:SetPosition()
    self:_SetPosition(self.barOrContainer)

    local anchorInfo = self:GetPositionAnchorInfo()

    ns.BUFSecureHandler.SaveAnchor(
        self.barOrContainer,
        "PlayerManaBarAnchor",
        anchorInfo
    )
    self.barOrContainer:SetAttribute("buf_restore_position", [[
        self:ClearAllPoints();
        self:SetPoint(unpack(PlayerManaBarAnchor));
    ]])
end
