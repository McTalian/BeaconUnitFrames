---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget: AceModule, AceHook-3.0, AceEvent-3.0
local BUFTarget = ns.BUF:NewModule("BUFTarget", "AceHook-3.0", "AceEvent-3.0")

ns.BUFTarget = BUFTarget

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = {
    enabled = true,
}

StaticPopupDialogs["BUF_RELOAD_UI"] = {
    text = ns.L["ReloadUIRequired"],
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function()
        ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

ns.options.args.unitFrames.args.target = {
    type = "group",
    name = ns.L["TargetFrame"],
    order = ns.BUFUnitFrames.optionsOrder.TARGET,
    childGroups = "tree",
    args = {
        enable = {
            type = "toggle",
            name = ENABLE,
            set = function(info, value)
                ns.db.profile.unitFrames.target.enabled = value
                if value then
                    BUFTarget:RefreshConfig()
                else
                    StaticPopup_Show("BUF_RELOAD_UI")
                end
            end,
            get = function(info)
                return ns.db.profile.unitFrames.target.enabled
            end,
            order = 0.01,
        },
    },
}

BUFTarget.optionsOrder = {
    FRAME = 1,
    PORTRAIT = 2,
    REPUTATION_BAR = 3,
    NAME = 4,
    LEVEL = 5,
    INDICATORS = 6,
    HEALTH = 7,
    POWER = 8,
}

function BUFTarget:OnEnable()
    self.frame = TargetFrame
    self.container = self.frame.TargetFrameContainer
    self.content = self.frame.TargetFrameContent
    self.contentMain = self.content.TargetFrameContentMain
    self.contentContextual = self.content.TargetFrameContentContextual
    self.healthBarContainer = self.contentMain.HealthBarsContainer
    self.healthBar = self.healthBarContainer.HealthBar
    self.manaBar = self.contentMain.ManaBar
    self.altPowerBar = self.frame.powerBarAlt
end

function BUFTarget:RefreshConfig()
    if not ns.db.profile.unitFrames.target.enabled then
        return
    end
    if not self.initialized then
        self.initialized = true
        if not ns.db.global.restoreCvars.showTempMaxHealthLoss then
            print("Storing original 'showTempMaxHealthLoss' CVar for restoration on shutdown.")
            ns.db.global.restoreCvars.showTempMaxHealthLoss = GetCVar("showTempMaxHealthLoss")
        end
        ns.db.RegisterCallback(ns, "OnDatabaseShutdown", function()
            print("Restoring 'showTempMaxHealthLoss' CVar to original value:", ns.db.global.restoreCvars.showTempMaxHealthLoss)
            SetCVar("showTempMaxHealthLoss", ns.db.global.restoreCvars.showTempMaxHealthLoss)
        end)
        SetCVar("showTempMaxHealthLoss", "0")

        self:SecureHook(self.frame, "Update", function()
            -- Be careful in here, if you do anything insecure, it could cause lua errors during combat
            self.Health.foregroundHandler:RefreshConfig()
            self.Power.foregroundHandler:RefreshConfig()
        end)

        self:SecureHook("UnitFrameManaBar_UpdateType", function(manaBar)
            if manaBar == self.manaBar then
                self.Power.foregroundHandler:RefreshConfig()
            end
        end)
    end
    self.Frame:RefreshConfig()
    self.Portrait:RefreshConfig()
    self.Name:RefreshConfig()
    self.Level:RefreshConfig()
    self.Indicators:RefreshConfig()
    self.Health:RefreshConfig()
    self.Power:RefreshConfig()
    self.ReputationBar:RefreshConfig()
end
