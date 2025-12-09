---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Health
local BUFBossHealth = BUFBoss.Health

---@class BUFBoss.Health.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.boss.healthBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFBossHealth.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Boss.Health.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 1, 0, 1 },
	useClassColor = false,
	useReactionColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, true, true, false)

---@class BUFDbSchema.UF.Boss.Health
ns.dbDefaults.profile.unitFrames.boss.healthBar = ns.dbDefaults.profile.unitFrames.boss.healthBar
ns.dbDefaults.profile.unitFrames.boss.healthBar.foreground = foregroundHandler.dbDefaults

ns.options.args.boss.args.healthBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		for i, bbi in ipairs(BUFBoss.frames) do
			bbi.health.foreground = {}
			bbi.health.foreground.statusBar = bbi.healthBar
			bbi.health.foreground.unit = "boss" .. i
		end
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Target-Boss-Small-PortraitOff-Bar-Health"
	end
	self:RefreshStatusBarForegroundConfig()
end

function foregroundHandler:RefreshStatusBarTexture()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshStatusBarTexture(bbi.health.foreground.statusBar)
	end
end

function foregroundHandler:RefreshColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshColor(bbi.health.foreground.statusBar, bbi.health.foreground.unit)
	end
end

BUFBossHealth.foregroundHandler = foregroundHandler
