---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Power
local BUFToTPower = BUFToT.Power

---@class BUFToT.Power.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.tot.powerBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFToTPower.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.ToT.Power.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.ToT.Power
ns.dbDefaults.profile.unitFrames.tot.powerBar = ns.dbDefaults.profile.unitFrames.tot.powerBar
ns.dbDefaults.profile.unitFrames.tot.powerBar.foreground = foregroundHandler.dbDefaults

ns.options.args.tot.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "targettarget"
		self.statusBar = BUFToT.manaBar
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana"
		self.maskTexture = BUFToT.manaBar.ManaBarMask
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

BUFToTPower.foregroundHandler = foregroundHandler
