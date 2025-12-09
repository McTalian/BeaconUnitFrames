---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Health
local BUFBossHealth = BUFBoss.Health

---@class BUFBoss.Health.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.boss.healthBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFBossHealth.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Boss.Health.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Boss.Health
ns.dbDefaults.profile.unitFrames.boss.healthBar = ns.dbDefaults.profile.unitFrames.boss.healthBar
ns.dbDefaults.profile.unitFrames.boss.healthBar.background = backgroundHandler.dbDefaults

ns.options.args.boss.args.healthBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		for i, bbi in ipairs(BUFBoss.frames) do
			bbi.health.background =
				bbi.healthBar:CreateTexture("BUFBoss" .. i .. "HealthBarBackground", "BACKGROUND", nil, 2)
			bbi.health.background:SetAllPoints(bbi.healthBar)
		end
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RefreshBackgroundTexture()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshBackgroundTexture(bbi.health.background)
	end
end

function backgroundHandler:RefreshColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshColor(bbi.health.background)
	end
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	for _, bbi in ipairs(BUFBoss.frames) do
		bbi.health.background:SetColorTexture(0, 0, 0, 0)
	end
end

BUFBossHealth.backgroundHandler = backgroundHandler
