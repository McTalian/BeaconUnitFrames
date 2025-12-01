---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators: BUFParentHandler
local BUFTargetIndicators = {}


BUFTargetIndicators.optionsOrder = {
  BOSS_PORTRAIT_FRAME_TEXTURE = 0.5,
  HIGH_LEVEL_TEXTURE = 1,
  LEADER_AND_GUIDE_ICON = 2,
  RAID_TARGET_ICON = 3,
  BOSS_ICON = 4,
  QUEST_ICON = 5,
  PVP_ICON = 6,
  PRESTIGE = 7,
  PET_BATTLE_ICON = 8,
}

local indicators = {
    type = "group",
    name = ns.L["Indicators and Icons"],
    order = BUFTarget.optionsOrder.INDICATORS,
    childGroups = "tree",
    args = {},
}

ns.options.args.target.args.indicators = indicators

function BUFTargetIndicators:RefreshConfig()
  self.BossPortraitFrameTexture:RefreshConfig()
  self.HighLevelTexture:RefreshConfig()
  self.LeaderAndGuideIcon:RefreshConfig()
  self.RaidTargetIcon:RefreshConfig()
  self.BossIcon:RefreshConfig()
  self.QuestIcon:RefreshConfig()
  self.PvPIcon:RefreshConfig()
  self.PrestigePortrait:RefreshConfig()
  self.PetBattleIcon:RefreshConfig()
end

BUFTarget.Indicators = BUFTargetIndicators
