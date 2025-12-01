---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health: BUFStatusBar
local BUFPlayerHealth = {
    configPath = "unitFrames.player.healthBar",
}

BUFPlayerHealth.optionsTable = {
    type = "group",
    handler = BUFPlayerHealth,
    name = HEALTH,
    order = BUFPlayer.optionsOrder.HEALTH,
    childGroups = "tree",
    args = {},
}

---@class BUFDbSchema.UF.Player.Health
BUFPlayerHealth.dbDefaults = {
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    width = 124,
    height = 20,
    xOffset = 85,
    yOffset = -40,
    frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFPlayerHealth)

BUFPlayer.Health = BUFPlayerHealth

local healthBarOrder = {}

ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.LEFT_TEXT = healthBarOrder.FRAME_LEVEL + .1
healthBarOrder.RIGHT_TEXT = healthBarOrder.LEFT_TEXT + .1
healthBarOrder.CENTER_TEXT = healthBarOrder.RIGHT_TEXT + .1
healthBarOrder.FOREGROUND = healthBarOrder.CENTER_TEXT + .1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + .1

BUFPlayerHealth.topGroupOrder = healthBarOrder

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@type BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = BUFPlayerHealth.dbDefaults

ns.options.args.player.args.healthBar = BUFPlayerHealth.optionsTable

BUFPlayerHealth.coeffs = {
    maskWidth = (128 / BUFPlayerHealth.dbDefaults.width),
    maskHeight = (32 / BUFPlayerHealth.dbDefaults.height),
    maskXOffset = (-1 / BUFPlayerHealth.dbDefaults.width),
    maskYOffset = (6 / BUFPlayerHealth.dbDefaults.height),
}

function BUFPlayerHealth:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        self.defaultRelativeTo = "PlayerFrame"
        self.defaultRelativePoint = "TOPLEFT"

        self.barOrContainer = BUFPlayer.healthBarContainer
        self.maskTexture = BUFPlayer.healthBarContainer.HealthBarMask
        self.maskTextureAtlas = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Mask"
        self.positionMask = true
    end
    if not InCombatLockdown() then
        self:RefreshStatusBarConfig()
    else
        self:SetUnprotectedSize()
        self.leftTextHandler:RefreshConfig()
        self.rightTextHandler:RefreshConfig()
        self.centerTextHandler:RefreshConfig()
        self.foregroundHandler:RefreshConfig()
        self.backgroundHandler:RefreshConfig()
    end
end

function BUFPlayerHealth:SetUnprotectedSize()
    local width = self:GetWidth()
    local height = self:GetHeight()

    self.maskTexture:SetWidth(width * self.coeffs.maskWidth)

    if BUFPlayer:IsHooked(self.maskTexture, "SetHeight") then
        BUFPlayer:Unhook(self.maskTexture, "SetHeight")
    end
    self.maskTexture:SetHeight(height * self.coeffs.maskHeight)
    if not BUFPlayer:IsHooked(self.maskTexture, "SetHeight") then
        BUFPlayer:SecureHook(self.maskTexture, "SetHeight", function()
            BUFPlayerHealth:SetUnprotectedSize()
        end)
    end

    if BUFPlayer:IsHooked(self.maskTexture, "SetPoint") then
        BUFPlayer:Unhook(self.maskTexture, "SetPoint")
    end
    self.maskTexture:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset,
        height * self.coeffs.maskYOffset)
    if not BUFPlayer:IsHooked(self.maskTexture, "SetPoint") then
        BUFPlayer:SecureHook(self.maskTexture, "SetPoint", function()
            BUFPlayerHealth:SetUnprotectedSize()
        end)
    end
end

function BUFPlayerHealth:SetSize()
    self:_SetSize(self.barOrContainer)
    self:_SetSize(BUFPlayer.healthBar)

    self:SetUnprotectedSize()

    local width, height = self:GetWidth(), self:GetHeight()
    local secureBody = format([[
        self:SetWidth(%d);
        self:SetHeight(%d);
    ]], width, height)

    self.barOrContainer:SetAttribute("buf_restore_size", secureBody)
    BUFPlayer.healthBar:SetAttribute("buf_restore_size", secureBody)
end

function BUFPlayerHealth:SetPosition()    
    self:_SetPosition(self.barOrContainer)

    ---@type AnchorInfo
    local anchorInfo = self:GetPositionAnchorInfo()

    ns.BUFSecureHandler.SaveAnchor(
        self.barOrContainer,
        "PlayerHealthBarAnchor",
        anchorInfo
    )
    self.barOrContainer:SetAttribute("buf_restore_position", [[
        self:ClearAllPoints();
        self:SetPoint(unpack(PlayerHealthBarAnchor));
    ]])
end
