---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power: BUFConfigHandler, Positionable, Sizable, Levelable
local BUFPetPower = {
    configPath = "unitFrames.pet.powerBar",
}

ns.Mixin(BUFPetPower, ns.Positionable, ns.Sizable, ns.Levelable)

BUFPet.Power = BUFPetPower

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

---@class BUFDbSchema.UF.Pet.Power
ns.dbDefaults.profile.unitFrames.pet.powerBar = {
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    width = 74,
    height = 7,
    xOffset = -4,
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

BUFPetPower.topGroupOrder = powerBarOrder

local powerBar = {
    type = "group",
    handler = BUFPetPower,
    name = POWER_TYPE_POWER,
    order = BUFPet.optionsOrder.POWER,
    childGroups = "tree",
    args = {},
}

ns.AddSizableOptions(powerBar.args, powerBarOrder)
ns.AddPositionableOptions(powerBar.args, powerBarOrder)
ns.AddFrameLevelOption(powerBar.args, powerBarOrder)

ns.options.args.unitFrames.args.pet.args.powerBar = powerBar

BUFPetPower.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-27 / ns.dbDefaults.profile.unitFrames.pet.powerBar.width),
    maskYOffset = 4 / ns.dbDefaults.profile.unitFrames.pet.powerBar.height,
}

function BUFPetPower:RefreshConfig()
    if not self.initialized then
        self.initialized = true
        self.defaultRelativeTo = PetFrameHealthBar
        self.defaultRelativePoint = "BOTTOMLEFT"
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

function BUFPetPower:SetSize()
    self:_SetSize(BUFPet.manaBar)
end

function BUFPetPower:SetPosition()
    self:_SetPosition(BUFPet.manaBar)
end

function BUFPetPower:SetLevel()
    local parent = BUFPet
    local frameLevel = ns.db.profile.unitFrames.pet.powerBar.frameLevel
    parent.manaBar:SetUsingParentLevel(false)
    parent.manaBar:SetFrameLevel(frameLevel)
end