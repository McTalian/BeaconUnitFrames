---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer: AceModule, AceHook-3.0
local BUFPlayer = ns.BUF:NewModule("BUFPlayer", "AceHook-3.0")

ns.BUFPlayer = BUFPlayer

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = {
    enabled = true,
}

ns.options.args.unitFrames.args.player = {
    type = "group",
    name = HUD_EDIT_MODE_PLAYER_FRAME_LABEL,
    order = 1,
    childGroups = "tree",
    args = {}
}

BUFPlayer.optionsOrder = {
    FRAME = 1,
    PORTRAIT = 2,
    NAME = 3,
    LEVEL = 4,
    INDICATORS = 5,
    HEALTH = 6,
    POWER = 7,
    CLASS_RESOURCES = 8,
}

function BUFPlayer:OnEnable()
    self.frame = PlayerFrame
    self.container = self.frame.PlayerFrameContainer
    self.content = self.frame.PlayerFrameContent
    self.contentMain = self.content.PlayerFrameContentMain
    self.contentContextual = PlayerFrame_GetPlayerFrameContentContextual()
    self.restLoop = self.contentContextual.PlayerRestLoop
    self.healthBarContainer = PlayerFrame_GetHealthBarContainer()
    self.healthBar = PlayerFrame_GetHealthBar()
    self.manaBarArea = self.contentMain.ManaBarArea
    self.manaBar = PlayerFrame_GetManaBar()
    self.altPowerBar = PlayerFrame_GetAlternatePowerBar()
end

function BUFPlayer:RefreshConfig()
    if not self.initialized then
        self.initialized = true
        
        local ArtUpdateListener = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
        ArtUpdateListener:SetAttribute("unit", "vehicle")
        RegisterUnitWatch(ArtUpdateListener, true)
        ArtUpdateListener:SetFrameRef("PlayerFrame", self.frame)
        ArtUpdateListener:SetFrameRef("HealthBarContainer", self.healthBarContainer)
        ArtUpdateListener:SetFrameRef("HealthBar", self.healthBar)
        ArtUpdateListener:SetFrameRef("ManaBar", self.manaBar)
        ArtUpdateListener:SetFrameRef("EmergencyFix", ns.emergencyFixButton)

        self:SecureHook("SecureButton_GetModifiedAttribute", function(s, n, b)
            if n == "attribute-frame" or n == "attribute-name" or n == "attribute-value" then
                print("SecureButton_GetModifiedAttribute", n, b)
                
                return
            end
        end)

        ns.emergencyFixButtonWrapper:Inject("PlayerVehicleListener", ArtUpdateListener)

        -- TODO: Need to figure out player name, level, and frame texture for player art
        -- Need to figure out vehicle frame for vehicle art

        ArtUpdateListener:SetAttribute("_onattributechanged", [[
            print(name, value)
            if name == "state-unitexists" then
                if value == true then
                    print("We finished entering a vehicle")
                else
                    print("We starting exiting a vehicle")
                    print("HasVehicleActionBar()", HasVehicleActionBar())
                    print("CanExitVehicle()", CanExitVehicle())
                    print("UnitHasVehicleUI()", UnitHasVehicleUI("player"))
                    print("IsMounted()", IsMounted())
                    print("IsFlying()", IsFlying())
                    local emergencyFix = self:GetFrameRef("EmergencyFix")
                    if PlayerInCombat() then
                        emergencyFix:Show()
                    end
                    return
                end
            end

            if name == "force-refresh" then
                print("Forcing a refresh:", value)
            end

            local healthBarContainer = self:GetFrameRef("HealthBarContainer")
            local healthBar = self:GetFrameRef("HealthBar")
            local manaBar = self:GetFrameRef("ManaBar")
            local playerFrame = self:GetFrameRef("PlayerFrame")
            
            healthBarContainer:RunAttribute("_childupdate-size", "test")
            healthBar:RunAttribute("_childupdate-size", "test")
            manaBar:RunAttribute("_childupdate-size", "test")

            healthBarContainer:RunAttribute("_childupdate-position", playerFrame)
            manaBar:RunAttribute("_childupdate-position", "test")
        ]])

        self:SecureHook("PlayerFrame_UpdateArt", function()
            if not InCombatLockdown() then
                self:RefreshConfig()
            else
                local frame = CreateFrame("Frame")
                frame:RegisterEvent("PLAYER_REGEN_ENABLED")
                frame:SetScript("OnEvent", function(self)
                    BUFPlayer:RefreshConfig()
                    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
                end)
            end
        end)

        ns.PlayerVehicleListener = ArtUpdateListener
    end
    self.Frame:RefreshConfig()
    self.Portrait:RefreshConfig()
    self.Name:RefreshConfig()
    self.Level:RefreshConfig()
    self.Indicators:RefreshConfig()
    self.Health:RefreshConfig()
    self.Power:RefreshConfig()
    self.ClassResources:RefreshConfig()
end

-- Hack to get around the art update issues when entering/exiting vehicles
-- The idea is to control sizing and positioning on a new frame that will be the parent
-- of the protected thing we want to control. (Assuming setting the parent doesn't cause taint issues)
-- Then creating N dummy frames that are slight offsets of our new frame so that right before things
-- get moved, we change the parent to the appropriate dummy frame that has the right offset.
-- This also relies on using SetAllPoints so that SetHeight/SetWidth calls are effectively ignored.
-- The snippet below is a test of that concept, but does not deal with the protected frames yet.

-- local testFrame = _G["McTestFrame"]
-- if not testFrame then
--    testFrame = CreateFrame("Frame", "McTestFrame", nil)
--    print("creating new")
-- end

-- if not testFrame.Background then
--    testFrame.Background = testFrame:CreateTexture()
-- end

-- local testSb = _G["McTestStatusBar"]
-- if not testSb then
--    testSb = CreateFrame("StatusBar", "McTestStatusBar", testFrame)
-- end

-- local testBgLayer = testFrame.Background
-- testBgLayer:SetAllPoints()
-- testBgLayer:SetColorTexture(1,1,1,1)

-- testFrame:SetPoint("CENTER")

-- testFrame:SetWidth(500)
-- testFrame:SetHeight(30)

-- testSb:SetAllPoints()
-- testSb:SetStatusBarTexture("Interface/TargetingFrame/UI-StatusBar")
-- testSb:SetStatusBarColor(0,1,0)
-- testSb:SetMinMaxValues(0,100)
-- testSb:SetValue(55)

-- testFrame:Show()

-- local dummyFrame = _G["McDummy"]
-- if not dummyFrame then
--    dummyFrame = CreateFrame("Frame", "McDummy", testFrame)
-- end

-- dummyFrame:SetPoint("TOPLEFT", 96, 10)
-- dummyFrame:SetPoint("BOTTOMRIGHT")


-- testSb:SetParent(dummyFrame)
-- testSb:SetAllPoints()
-- testSb:SetPoint("TOPLEFT", -96, -10)
-- testSb:SetWidth(20)
-- testSb:SetHeight(500)

