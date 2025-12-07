---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Health
local BUFFocusHealth = BUFFocus.Health

---@class BUFFocus.Health.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.focus.healthBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFFocusHealth.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Focus.Health.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 1, 0, 1 },
	useClassColor = false,
	useReactionColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, true, true, false)

---@class BUFDbSchema.UF.Focus.Health
ns.dbDefaults.profile.unitFrames.focus.healthBar = ns.dbDefaults.profile.unitFrames.focus.healthBar
ns.dbDefaults.profile.unitFrames.focus.healthBar.foreground = foregroundHandler.dbDefaults

ns.options.args.focus.args.healthBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "focus"
		self.statusBar = BUFFocus.healthBar
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health"
	end
	self:RefreshStatusBarForegroundConfig()
end

BUFFocusHealth.foregroundHandler = foregroundHandler
