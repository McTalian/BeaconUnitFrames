---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.target.healthBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFTargetHealth.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Target.Health.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 1, 0, 1 },
	useClassColor = false,
	useReactionColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, true, true, false)

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar
ns.dbDefaults.profile.unitFrames.target.healthBar.foreground = foregroundHandler.dbDefaults

ns.options.args.target.args.healthBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "target"
		self.statusBar = BUFTarget.healthBar
	end
	self:RefreshStatusBarForegroundConfig()
end

BUFTargetHealth.foregroundHandler = foregroundHandler
