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
        
        self.ArtUpdateListener = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")

        self.ArtUpdateListener:SetFrameRef("PlayerHealthContainer", self.healthBarContainer)
        self.ArtUpdateListener:SetFrameRef("PlayerHealthBar", self.healthBar)
        self.ArtUpdateListener:SetFrameRef("PlayerManaBar", self.manaBar)

        function self.ArtUpdateListener:RunSecure()
            local playerDb = ns.db.profile.unitFrames.player
            self:Execute(format([[
                local healthContainer = self:GetFrameRef("PlayerHealthContainer")
                local healthBar = self:GetFrameRef("PlayerHealthBar")
                local manaBar = self:GetFrameRef("PlayerManaBar")

                healthContainer:SetWidth(%d)
                healthContainer:SetHeight(%d)
                healthBar:SetWidth(%d)
                healthBar:SetHeight(%d)
                manaBar:SetWidth(%d)
                manaBar:SetHeight(%d)
            ]]),
                playerDb.healthBar.width,
                playerDb.healthBar.height,
                playerDb.healthBar.width,
                playerDb.healthBar.height,
                playerDb.powerBar.width,
                playerDb.powerBar.height
            )
        end

        self:SecureHook("PlayerFrame_UpdateArt", function()
            BUFPlayer.ArtUpdateListener:RunSecure()
        end)
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
