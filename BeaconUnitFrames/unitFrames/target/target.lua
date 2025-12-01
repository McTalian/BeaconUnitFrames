---@class BUFNamespace
local ns = select(2, ...)

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

ns.options.args.target = {
    type = "group",
    name = HUD_EDIT_MODE_TARGET_FRAME_LABEL,
    order = ns.BUFUnitFrames.optionsOrder.TARGET,
    childGroups = "tree",
    disabled = function()
        return not ns.db.profile.unitFrames.target.enabled
    end,
    args = {
        title = {
            type = "header",
            name = HUD_EDIT_MODE_TARGET_FRAME_LABEL,
            order = 0.001,
        },
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
            disabled = false,
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
        local ClassificationCheckUpdater = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
        Mixin(ClassificationCheckUpdater, ns.BUFSecureHandler)

        -- healthBarsContainer gets moved during CheckClassification
        -- if we don't anchor anything to it, we can avoid having to reapply our position/size changes
        -- leaving this in here in case there ever turns out to be a reliable secure trigger
        ClassificationCheckUpdater:SecureSetFrameRef("TargetHealthBarContainer", self.healthBarContainer)
        ClassificationCheckUpdater:SecureSetFrameRef("TargetHealthBar", self.healthBar)
        ClassificationCheckUpdater:SecureSetFrameRef("TargetManaBar", self.manaBar)

        ns.TargetClassificationCheckUpdater = ClassificationCheckUpdater
    end
    self.Frame:RefreshConfig()
    self.Portrait:RefreshConfig()
    self.Name:RefreshConfig()
    self.Level:RefreshConfig()
    self.Indicators:RefreshConfig()
    self.Health:RefreshConfig()
    self.Power:RefreshConfig()
    self.ReputationBar:RefreshConfig()

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

        -- We won't end up actually triggering anything but keeping the code here
        -- in case something changes in the future.
        local ClassificationCheckUpdater = ns.TargetClassificationCheckUpdater

        ClassificationCheckUpdater:SetAttribute("buf_restore_size_position",[[
            TargetHealthBarContainer:RunAttribute("buf_restore_size")
            -- TargetHealthBar:RunAttribute("buf_restore_size")
            -- TargetManaBar:RunAttribute("buf_restore_size")
            
            -- TargetHealthBarContainer:RunAttribute("buf_restore_position")
            -- TargetManaBar:RunAttribute("buf_restore_position")
            print("Restored sizes/positions for Target Health and Mana Bars.")
        ]])

        ClassificationCheckUpdater:SetAttribute("_onattributechanged", [[
            self:RunAttribute("buf_restore_size_position")
            if name == "manual" then
                return
            end
        ]])

        -- I need something to securely trigger the classification check updater when the target changes
        -- but for now, we'll just completely ignore healthBarsContainer in anchors
    end
end
