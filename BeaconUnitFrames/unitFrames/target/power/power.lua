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

ns.Mixin(BUFTargetPower, ns.Sizable, ns.Positionable, ns.Levelable)

BUFTarget.Power = BUFTargetPower

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = {
    width = 134,
    height = 10,
    anchorPoint = "TOPRIGHT",
    relativeTo = "TargetFrame",
    relativePoint = "BOTTOMRIGHT",
    xOffset = 8,
    yOffset = -1,
    frameLevel = 3,
}

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + .1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + .1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + .1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + .1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + .1

BUFTargetPower.topGroupOrder = powerBarOrder

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
    self:InitializeTargetPower()
    self:SetPosition()
    self:SetSize()
    self:SetLevel()
    self.leftTextHandler:RefreshConfig()
    self.rightTextHandler:RefreshConfig()
    self.centerTextHandler:RefreshConfig()
    self.foregroundHandler:RefreshConfig()
    -- self.backgroundHandler:RefreshConfig()
end

function BUFTargetPower:InitializeTargetPower()
    if self.isInitialized then
        return
    end

    self.isInitialized = true

    local parent = BUFTarget
    parent.manaBar.ManaBarMask:Hide()
    if not ns.BUFTarget:IsHooked(parent.manaBar.ManaBarMask, "SetAtlas") then
        ns.BUFTarget:SecureHook(parent.manaBar.ManaBarMask, "SetAtlas", function(s)
            print("SetAtlas called on Target Power Bar ManaBarMask.")
        end)
    end
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
    parent.manaBar:ClearAllPoints()
    parent.manaBar:SetPoint(
        ns.db.profile.unitFrames.target.powerBar.anchorPoint,
        _G[ns.db.profile.unitFrames.target.powerBar.relativeTo],
        ns.db.profile.unitFrames.target.powerBar.relativePoint,
        xOffset,
        yOffset
    )
end

function BUFTargetPower:SetLevel()
    local parent = BUFTarget
    local frameLevel = ns.db.profile.unitFrames.target.powerBar.frameLevel
    parent.manaBar:SetUsingParentLevel(false)
    parent.manaBar:SetFrameLevel(frameLevel)
end