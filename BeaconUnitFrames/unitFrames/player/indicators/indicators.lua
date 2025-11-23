---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators: BUFConfigHandler
local BUFPlayerIndicators = {}


BUFPlayerIndicators.optionsOrder = {
  GROUP_INDICATOR = 1,
  REST_INDICATOR = 2,
  ATTACK_ICON = 3,
  READY_CHECK_INDICATOR = 4,
  ROLE_ICON = 5,
  LEADER_AND_GUIDE_ICON = 6,
  PVP_ICON = 7,
  PRESTIGE = 8,
  PLAY_TIME = 9,
}

local indicators = {
    type = "group",
    name = ns.L["Indicators and Icons"],
    order = BUFPlayer.optionsOrder.INDICATORS,
    childGroups = "tree",
    args = {},
}

ns.options.args.unitFrames.args.player.args.indicators = indicators

function BUFPlayerIndicators:RefreshConfig()
    self.AttackIcon:RefreshConfig()
    self.GroupIndicator:RefreshConfig()
    self.LeaderAndGuideIcon:RefreshConfig()
    self.PlayTime:RefreshConfig()
    self.PrestigePortrait:RefreshConfig()
    self.PvPIcon:RefreshConfig()
    self.ReadyCheckIndicator:RefreshConfig()
    self.RestIndicator:RefreshConfig()
    self.RoleIcon:RefreshConfig()
end

BUFPlayer.Indicators = BUFPlayerIndicators
