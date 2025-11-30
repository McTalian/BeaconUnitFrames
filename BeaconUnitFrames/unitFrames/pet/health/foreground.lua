---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Health
local BUFPetHealth = BUFPet.Health

---@class BUFPet.Health.Foreground: BUFConfigHandler, StatusBarForeground
local foregroundHandler = {
    configPath = "unitFrames.pet.healthBar.foreground",
}

foregroundHandler.optionsTable = {
    type = "group",
    handler = foregroundHandler,
    name = ns.L["Foreground"],
    order = BUFPetHealth.topGroupOrder.FOREGROUND,
    args = {}
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, true, false, false)

---@class BUFDbSchema.UF.Pet.Health
ns.dbDefaults.profile.unitFrames.pet.healthBar = ns.dbDefaults.profile.unitFrames.pet.healthBar

ns.dbDefaults.profile.unitFrames.pet.healthBar.foreground = {
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useCustomColor = false,
    customColor = { 0, 1, 0, 1 },
    useClassColor = false,
}

ns.options.args.pet.args.healthBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        self.unit = "pet"
        self.statusBar = ns.BUFPet.healthBar
        self.statusBarMask = PetFrameHealthBarMask
        self.defaultStatusBarMaskTexture = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health-Mask"
    end
    self:RefreshStatusBarForegroundConfig()
end

BUFPetHealth.foregroundHandler = foregroundHandler
