---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators: BUFParentHandler
local BUFFocusIndicators = {}

BUFFocusIndicators.optionsOrder = {
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
	order = BUFFocus.optionsOrder.INDICATORS,
	childGroups = "tree",
	args = {},
}

ns.options.args.focus.args.indicators = indicators

function BUFFocusIndicators:RefreshConfig()
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

BUFFocus.Indicators = BUFFocusIndicators
