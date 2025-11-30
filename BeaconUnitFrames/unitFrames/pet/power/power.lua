---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power: BUFConfigHandler, BUFStatusBar
local BUFPetPower = {
    configPath = "unitFrames.pet.powerBar",
}

BUFPetPower.optionsTable = {
    type = "group",
    handler = BUFPetPower,
    name = POWER_TYPE_POWER,
    order = BUFPet.optionsOrder.POWER,
    childGroups = "tree",
    args = {},
}

ns.BUFStatusBar:ApplyMixin(BUFPetPower)

---@class BUFDbSchema.UF.Pet.Power
BUFPetPower.dbDefaults = {
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    width = 74,
    height = 7,
    xOffset = -4,
    yOffset = -1,
    frameLevel = 3,
}

BUFPet.Power = BUFPetPower

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

ns.dbDefaults.profile.unitFrames.pet.powerBar = BUFPetPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + .1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + .1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + .1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + .1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + .1

BUFPetPower.topGroupOrder = powerBarOrder

ns.options.args.unitFrames.args.pet.args.powerBar = BUFPetPower.optionsTable

BUFPetPower.coeffs = {
    maskWidth = (128 / ns.dbDefaults.profile.unitFrames.pet.powerBar.width),
    maskHeight = (16 / ns.dbDefaults.profile.unitFrames.pet.powerBar.height),
    maskXOffset = (-27 / ns.dbDefaults.profile.unitFrames.pet.powerBar.width),
    maskYOffset = 4 / ns.dbDefaults.profile.unitFrames.pet.powerBar.height,
}

function BUFPetPower:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        self.defaultRelativeTo = PetFrameHealthBar
        self.defaultRelativePoint = "BOTTOMLEFT"

        self.barOrContainer = PetFrameManaBar
        self.maskTexture = PetFrameManaBarMask
        self.maskTextureAtlas = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana-Mask"
        self.positionMask = false
    end
    self:RefreshStatusBarConfig()
    -- self.backgroundHandler:RefreshConfig()
end
