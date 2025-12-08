---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Power
local BUFToFocusPower = BUFToFocus.Power

---@class BUFToFocus.Power.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.tofocus.powerBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFToFocusPower.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.ToFocus.Power.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.ToFocus.Power
ns.dbDefaults.profile.unitFrames.tofocus.powerBar = ns.dbDefaults.profile.unitFrames.tofocus.powerBar
ns.dbDefaults.profile.unitFrames.tofocus.powerBar.foreground = foregroundHandler.dbDefaults

ns.options.args.tofocus.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "focustarget"
		self.statusBar = BUFToFocus.manaBar
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana"
		self.maskTexture = BUFToFocus.manaBar.ManaBarMask
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

BUFToFocusPower.foregroundHandler = foregroundHandler
