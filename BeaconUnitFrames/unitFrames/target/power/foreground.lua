---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.target.powerBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFTargetPower.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Target.Power.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar
ns.dbDefaults.profile.unitFrames.target.powerBar.foreground = foregroundHandler.dbDefaults

ns.options.args.target.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "target"
		self.statusBar = BUFTarget.manaBar
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana"
		self.maskTexture = BUFTarget.manaBar.ManaBarMask
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

BUFTargetPower.foregroundHandler = foregroundHandler
