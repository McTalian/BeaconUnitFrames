---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Power
local BUFFocusPower = BUFFocus.Power

---@class BUFFocus.Power.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.focus.powerBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFFocusPower.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Focus.Power.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.Focus.Power
ns.dbDefaults.profile.unitFrames.focus.powerBar = ns.dbDefaults.profile.unitFrames.focus.powerBar
ns.dbDefaults.profile.unitFrames.focus.powerBar.foreground = foregroundHandler.dbDefaults

ns.options.args.focus.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "focus"
		self.statusBar = BUFFocus.manaBar
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana"
		self.maskTexture = BUFFocus.manaBar.ManaBarMask
	end
	self:RefreshStatusBarForegroundConfig()
end

function foregroundHandler:RefreshStatusBarTexture()
	self:_RefreshStatusBarTexture(self.statusBar)
	local useCustomTexture = self:GetUseStatusBarTexture()
	if useCustomTexture then
		self.maskTexture:Hide()
	end
end

BUFFocusPower.foregroundHandler = foregroundHandler
