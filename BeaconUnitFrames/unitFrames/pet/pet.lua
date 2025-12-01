---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet: AceModule, AceHook-3.0, AceEvent-3.0
local BUFPet = ns.BUF:NewModule("BUFPet", "AceHook-3.0", "AceEvent-3.0")

ns.BUFPet = BUFPet

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = {
    enabled = true,
}

ns.options.args.pet = {
    type = "group",
    name = HUD_EDIT_MODE_PET_FRAME_LABEL,
    order = ns.BUFUnitFrames.optionsOrder.PET,
    childGroups = "tree",
    disabled = function()
        return not ns.db.profile.unitFrames.pet.enabled
    end,
    args = {
        title = {
            type = "header",
            name = HUD_EDIT_MODE_PET_FRAME_LABEL,
            order = 0.001,
        },
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
            disabled = false,
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
    if not ns.db.profile.unitFrames.pet.enabled then
        return
    end

    if InCombatLockdown() then
        if not self.regenRegistered then
            self.regenRegistered = true
            self:RegisterEvent("PLAYER_REGEN_ENABLED", "RefreshConfig")
        end
        -- Refresh the config that does not require a secure environment
        self.Portrait:RefreshConfig()
        self.Name:RefreshConfig()
        self.Indicators:RefreshConfig()
        self.Health:RefreshConfig()
        self.Power:RefreshConfig()
        return
    else
        if self.regenRegistered then
            self.regenRegistered = false
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end
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

        self:SecureHook("PlayerFrame_UpdateArt", function()
            self:RefreshConfig()
            self.Health.foregroundHandler:RefreshConfig()
            self.Power.foregroundHandler:RefreshConfig()
        end)
    end
end