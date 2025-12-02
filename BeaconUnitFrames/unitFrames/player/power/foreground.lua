---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.player.powerBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFPlayerPower.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Player.Power.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

BUFPlayerPower.foregroundHandler = foregroundHandler

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.foreground = foregroundHandler.dbDefaults

ns.options.args.player.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "player"
		self.statusBar = BUFPlayer.manaBar

		local powerType, _ = UnitPowerType("player")

		local commonPrefix = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-"

		if powerType == Enum.PowerType.Mana then
			self.defaultStatusBarTexture = commonPrefix .. "Mana"
		elseif powerType == Enum.PowerType.Rage then
			self.defaultStatusBarTexture = commonPrefix .. "Rage"
		elseif powerType == Enum.PowerType.Energy then
			self.defaultStatusBarTexture = commonPrefix .. "Energy"
		elseif powerType == Enum.PowerType.Focus then
			self.defaultStatusBarTexture = commonPrefix .. "Focus"
		elseif powerType == Enum.PowerType.RunicPower then
			self.defaultStatusBarTexture = commonPrefix .. "RunicPower"
		else
			self.defaultStatusBarTexture = commonPrefix .. "Mana"
		end

		if not BUFPlayer:IsHooked("UnitFrameManaBar_UpdateType") then
			BUFPlayer:SecureHook("UnitFrameManaBar_UpdateType", function()
				self:RefreshStatusBarForegroundConfig()
			end)
		end
	end
	self:RefreshStatusBarForegroundConfig()
end
