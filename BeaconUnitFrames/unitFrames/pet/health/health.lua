---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Health: BUFConfigHandler, BUFStatusBar
local BUFPetHealth = {
    configPath = "unitFrames.pet.healthBar",
}

BUFPetHealth.optionsTable = {
    type = "group",
    handler = BUFPetHealth,
    name = HEALTH,
    order = BUFPet.optionsOrder.HEALTH,
    childGroups = "tree",
    args = {},
}

ns.BUFStatusBar:ApplyMixin(BUFPetHealth)

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

ns.options.args.unitFrames.args.pet.args.healthBar = BUFPetHealth.optionsTable

BUFPetHealth.coeffs = {
    maskWidth = (128 / ns.dbDefaults.profile.unitFrames.pet.healthBar.width),
    maskHeight = (16 / ns.dbDefaults.profile.unitFrames.pet.healthBar.height),
    maskXOffset = (-29 / ns.dbDefaults.profile.unitFrames.pet.healthBar.width),
    maskYOffset = (3 / ns.dbDefaults.profile.unitFrames.pet.healthBar.height),
}

function BUFPetHealth:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        self.defaultRelativeTo = PetPortrait
        self.defaultRelativePoint = "RIGHT"

        self.barOrContainer = PetFrameHealthBar
        self.maskTexture = PetFrameHealthBarMask
        self.maskTextureAtlas = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health-Mask"
        self.positionMask = true
    end
    self:RefreshStatusBarConfig()
end
