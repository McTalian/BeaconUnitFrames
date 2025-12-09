---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Health: BUFStatusBar
local BUFBossHealth = {
	configPath = "unitFrames.boss.healthBar",
	frameKey = BUFBoss.relativeToFrames.HEALTH,
}

BUFBossHealth.optionsTable = {
	type = "group",
	handler = BUFBossHealth,
	name = HEALTH,
	order = BUFBoss.optionsOrder.HEALTH,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss

---@class BUFDbSchema.UF.Boss.Health
ns.dbDefaults.profile.unitFrames.boss.healthBar = {
	width = 126,
	height = 20,
	anchorPoint = "BOTTOMRIGHT",
	relativeTo = BUFBoss.relativeToFrames.FRAME,
	relativePoint = "LEFT",
	xOffset = 148,
	yOffset = 2,
	frameLevel = 3,
}

local healthBarOrder = {}
ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.LEFT_TEXT = healthBarOrder.FRAME_LEVEL + 0.1
healthBarOrder.RIGHT_TEXT = healthBarOrder.LEFT_TEXT + 0.1
healthBarOrder.CENTER_TEXT = healthBarOrder.RIGHT_TEXT + 0.1
healthBarOrder.DEAD_TEXT = healthBarOrder.CENTER_TEXT + 0.1
healthBarOrder.UNCONSCIOUS_TEXT = healthBarOrder.DEAD_TEXT + 0.1
healthBarOrder.FOREGROUND = healthBarOrder.UNCONSCIOUS_TEXT + 0.1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + 0.1

BUFBossHealth.topGroupOrder = healthBarOrder

ns.options.args.boss.args.healthBar = BUFBossHealth.optionsTable

ns.BUFStatusBar:ApplyMixin(BUFBossHealth)
ns.Mixin(BUFBossHealth, ns.BUFBossPositionable)

function BUFBossHealth:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.health = {}
			bbi.health.barOrContainer = bbi.healthBar
			bbi.health.barOrContainer.bufOverrideParentFrame = bbi.frame
		end
	end
	self:RefreshStatusBarConfig()
end

function BUFBossHealth:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.health.barOrContainer)
	end
end

function BUFBossHealth:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.health.barOrContainer)
	end
end

function BUFBossHealth:SetLevel()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetLevel(bbi.health.barOrContainer)
	end
end

BUFBoss.Health = BUFBossHealth
