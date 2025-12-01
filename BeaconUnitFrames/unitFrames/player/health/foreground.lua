---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.player.healthBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFPlayerHealth.topGroupOrder.FOREGROUND,
	args = {},
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, true, false, false)

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar

ns.dbDefaults.profile.unitFrames.player.healthBar.foreground = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 1, 0, 1 },
	useClassColor = false,
}

ns.options.args.player.args.healthBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "player"
		self.statusBar = ns.BUFPlayer.healthBar
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health"
	end
	self:RefreshStatusBarForegroundConfig()
end

BUFPlayerHealth.foregroundHandler = foregroundHandler
