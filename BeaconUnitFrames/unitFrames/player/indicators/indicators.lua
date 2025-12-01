---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators: BUFParentHandler
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
	HIT_INDICATOR = 9,
	PLAY_TIME = 10,
}

local indicators = {
	type = "group",
	name = ns.L["Indicators and Icons"],
	order = BUFPlayer.optionsOrder.INDICATORS,
	childGroups = "tree",
	args = {},
}

ns.options.args.player.args.indicators = indicators

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
	self.HitIndicator:RefreshConfig()
end

BUFPlayer.Indicators = BUFPlayerIndicators
