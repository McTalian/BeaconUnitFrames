---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Health
local BUFToFocusHealth = BUFToFocus.Health

---@class BUFToFocus.Health.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.tofocus.healthBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFToFocusHealth.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.ToFocus.Health.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 1, 0, 1 },
	useClassColor = false,
	useReactionColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, true, true, false)

---@class BUFDbSchema.UF.ToFocus.Health
ns.dbDefaults.profile.unitFrames.tofocus.healthBar = ns.dbDefaults.profile.unitFrames.tofocus.healthBar
ns.dbDefaults.profile.unitFrames.tofocus.healthBar.foreground = foregroundHandler.dbDefaults

ns.options.args.tofocus.args.healthBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "focustarget"
		self.statusBar = BUFToFocus.healthBar
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health"
	end
	self:RefreshStatusBarForegroundConfig()
end

BUFToFocusHealth.foregroundHandler = foregroundHandler
