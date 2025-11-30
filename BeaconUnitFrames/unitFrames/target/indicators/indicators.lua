---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators: BUFConfigHandler
local BUFTargetIndicators = {}


BUFTargetIndicators.optionsOrder = {
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
  self.HighLevelTexture:RefreshConfig()
  self.LeaderAndGuideIcon:RefreshConfig()
end

BUFTarget.Indicators = BUFTargetIndicators
