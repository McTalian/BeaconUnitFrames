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
    args = {}
}

BUFPlayer.optionsOrder = {
    FRAME = 1,
    PORTRAIT = 2,
    NAME = 3,
    LEVEL = 4,
    HEALTH = 5,
    MANA = 6,
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
    self:SetFrameSize()
    self:ShowHidePortrait()
    self:SetNameFont()
    self:SetHealthPosition()
    self:SetHealthSize()
    self:SetHealthStatusBarTexture()
    self:SetHealthColor()
    self:SetManaPosition()
    self:SetManaSize()
end

-- local BUF = _G.BeaconUnitFrames
-- local t = BUF.lsm:Fetch("statusbar", "Blizzard")
-- local hb = PlayerFrame_GetHealthBar()
-- hb:SetStatusBarTexture(t)
-- local _, c = UnitClass("player")
-- local r,g,b,hex = GetClassColor(c)
-- hb:SetStatusBarColor(r, g, b, 1.0)

-- PlayerName:ClearAllPoints()
-- PlayerName:SetPoint("BOTTOMLEFT", healthBarContainer, "TOPLEFT", 4, 1)
-- PlayerLevelText:ClearAllPoints()
-- PlayerLevelText:SetPoint("BOTTOMRIGHT", healthBarContainer, "TOPRIGHT", -4, 1)

-- restLoop.RestTexture:ClearAllPoints()
-- restLoop.RestTexture:SetPoint("BOTTOMLEFT", PlayerLevelText, "TOPRIGHT")
