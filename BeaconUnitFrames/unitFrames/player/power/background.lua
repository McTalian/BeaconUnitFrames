---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.player.powerBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFPlayerPower.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Player.Power.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar
ns.dbDefaults.profile.unitFrames.player.powerBar.background = backgroundHandler.dbDefaults

ns.options.args.player.args.powerBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFPlayer.manaBar:CreateTexture("BUFPlayerPowerBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFPlayer.manaBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFPlayerPower.backgroundHandler = backgroundHandler
