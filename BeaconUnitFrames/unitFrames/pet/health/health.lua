---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Health: BUFConfigHandler, Positionable, Sizable, Levelable
local BUFPetHealth = {
    configPath = "unitFrames.pet.healthBar",
}

ns.Mixin(BUFPetHealth, ns.Positionable, ns.Sizable, ns.Levelable)

BUFPet.Health = BUFPetHealth

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

---@class BUFDbSchema.UF.Pet.Health
ns.dbDefaults.profile.unitFrames.pet.healthBar = {
    width = 70,
    height = 10,
    anchorPoint = "BOTTOMLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = "RIGHT",
    xOffset = 2,
    yOffset = -3.5,
    frameLevel = 3,
}

local healthBarOrder = {}

ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.LEFT_TEXT = healthBarOrder.FRAME_LEVEL + .1
healthBarOrder.RIGHT_TEXT = healthBarOrder.LEFT_TEXT + .1
healthBarOrder.CENTER_TEXT = healthBarOrder.RIGHT_TEXT + .1
healthBarOrder.FOREGROUND = healthBarOrder.CENTER_TEXT + .1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + .1

BUFPetHealth.topGroupOrder = healthBarOrder

local healthBar = {
    type = "group",
    handler = BUFPetHealth,
    name = HEALTH,
    order = BUFPet.optionsOrder.HEALTH,
    childGroups = "tree",
    args = {},
}

ns.AddSizableOptions(healthBar.args, healthBarOrder)
ns.AddPositionableOptions(healthBar.args, healthBarOrder)
ns.AddFrameLevelOption(healthBar.args, healthBarOrder)

ns.options.args.unitFrames.args.pet.args.healthBar = healthBar

BUFPetHealth.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-29 / ns.dbDefaults.profile.unitFrames.pet.healthBar.width),
    maskYOffset = 3 / ns.dbDefaults.profile.unitFrames.pet.healthBar.height,
}

function BUFPetHealth:RefreshConfig()
    if not self.initialized then
        self.initialized = true
        self.defaultRelativeTo = PetPortrait
        self.defaultRelativePoint = "RIGHT"
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

function BUFPetHealth:SetSize()
    self:_SetSize(PetFrameHealthBar)
    self:_SetSize(PetFrameHealthBarMask)
    
end

function BUFPetHealth:SetPosition()
    self:_SetPosition(PetFrameHealthBar)
end

function BUFPetHealth:SetLevel()
    local parent = BUFPet
    local frameLevel = ns.db.profile.unitFrames.pet.healthBar.frameLevel
    parent.healthBar:SetUsingParentLevel(false)
    parent.healthBar:SetFrameLevel(frameLevel)
end
