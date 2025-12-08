---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Health
local BUFToTHealth = BUFToT.Health

---@class BUFToT.Health.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.tot.healthBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFToTHealth.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.ToT.Health.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 1, 0, 1 },
	useClassColor = false,
	useReactionColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, true, true, false)

---@class BUFDbSchema.UF.ToT.Health
ns.dbDefaults.profile.unitFrames.tot.healthBar = ns.dbDefaults.profile.unitFrames.tot.healthBar
ns.dbDefaults.profile.unitFrames.tot.healthBar.foreground = foregroundHandler.dbDefaults

ns.options.args.tot.args.healthBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "targettarget"
		self.statusBar = BUFToT.healthBar
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health"
	end
	self:RefreshStatusBarForegroundConfig()
end

BUFToTHealth.foregroundHandler = foregroundHandler
