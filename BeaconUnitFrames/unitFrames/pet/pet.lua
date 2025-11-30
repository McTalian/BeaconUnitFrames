---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet: AceModule, AceHook-3.0, AceEvent-3.0
local BUFPet = ns.BUF:NewModule("BUFPet", "AceHook-3.0", "AceEvent-3.0")

ns.BUFPet = BUFPet

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = {
    enabled = true,
}

ns.options.args.unitFrames.args.pet = {
    type = "group",
    name = PET_TYPE_PET,
    order = ns.BUFUnitFrames.optionsOrder.PET,
    childGroups = "tree",
    args = {
        enable = {
            type = "toggle",
            name = ENABLE,
            set = function(info, value)
                ns.db.profile.unitFrames.pet.enabled = value
                if value then
                    BUFPet:RefreshConfig()
                else
                    StaticPopup_Show("BUF_RELOAD_UI")
                end
            end,
            get = function(info)
                return ns.db.profile.unitFrames.pet.enabled
            end,
            order = 0.01,
        },
    }
}

BUFPet.optionsOrder = {
    FRAME = 1,
    PORTRAIT = 2,
    NAME = 3,
    LEVEL = 4,
    INDICATORS = 5,
    HEALTH = 6,
    POWER = 7,
    CLASS_RESOURCES = 8,
}

function BUFPet:OnEnable()
    self.frame = PetFrame
    self.healthBar = PetFrameHealthBar
    self.manaBar = PetFrameManaBar
end

function BUFPet:RefreshConfig(_eName)
    if _eName then
        print("BUFPet:RefreshConfig called due to event:", _eName)
    end
    if not ns.db.profile.unitFrames.pet.enabled then
        return
    end

    self.Frame:RefreshConfig()
    self.Portrait:RefreshConfig()
    self.Name:RefreshConfig()
    self.Indicators:RefreshConfig()
    self.Health:RefreshConfig()
    self.Power:RefreshConfig()

    if not self.initialized then
        self.initialized = true

        self:RegisterEvent("PET_UI_UPDATE", "RefreshConfig")

        if not self:IsHooked(PetFrame, "Update") then
            self:SecureHook(PetFrame, "Update", function()
                self:RefreshConfig()
            end)
        end
    end
end