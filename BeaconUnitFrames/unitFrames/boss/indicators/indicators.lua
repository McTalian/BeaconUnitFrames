---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Indicators: BUFParentHandler
local BUFBossIndicators = {}

BUFBossIndicators.optionsOrder = {
	BOSS_PORTRAIT_FRAME_TEXTURE = 0.5,
	HIGH_LEVEL_TEXTURE = 1,
	RAID_TARGET_ICON = 2,
	BOSS_ICON = 3,
	QUEST_ICON = 4,
}

local indicators = {
	type = "group",
	name = ns.L["Indicators and Icons"],
	order = BUFBoss.optionsOrder.INDICATORS,
	childGroups = "tree",
	args = {},
}

ns.options.args.boss.args.indicators = indicators

function BUFBossIndicators:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.indicators = {}
		end
	end
	self.BossPortraitFrameTexture:RefreshConfig()
	self.HighLevelTexture:RefreshConfig()
	self.RaidTargetIcon:RefreshConfig()
	self.BossIcon:RefreshConfig()
	self.QuestIcon:RefreshConfig()
end

BUFBoss.Indicators = BUFBossIndicators
