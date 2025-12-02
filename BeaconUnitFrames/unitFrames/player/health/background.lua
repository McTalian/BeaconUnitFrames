---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.player.healthBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFPlayerHealth.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Player.Health.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 1 }, -- BLACK_FONT_COLOR
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar
ns.dbDefaults.profile.unitFrames.player.healthBar.background = backgroundHandler.dbDefaults

ns.options.args.player.args.healthBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFPlayer.healthBar.Background
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	local default = BLACK_FONT_COLOR
	self.background:SetColorTexture(default.r, default.g, default.b, default.a)
end

BUFPlayerHealth.backgroundHandler = backgroundHandler
