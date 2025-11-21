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
    GROUP_INDICATOR = 5,
    REST_INDICATOR = 6,
    PLAY_TIME = 7,
    HEALTH = 8,
    POWER = 9,
    CLASS_RESOURCES = 10,
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
    print("Refreshing Player Frame Config")
    self.Frame:RefreshConfig()
    self.Portrait:RefreshConfig()
    self.Name:RefreshConfig()
    self.Level:RefreshConfig()
    self.GroupIndicator:RefreshConfig()
    self.RestIndicator:RefreshConfig()
    self.PlayTime:RefreshConfig()
    self.Health:RefreshConfig()
    self.Power:RefreshConfig()
    self.ClassResources:RefreshConfig()
end
