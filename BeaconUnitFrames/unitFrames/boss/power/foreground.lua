---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Power
local BUFBossPower = BUFBoss.Power

---@class BUFBoss.Power.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.boss.powerBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFBossPower.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Boss.Power.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.Boss.Power
ns.dbDefaults.profile.unitFrames.boss.powerBar = ns.dbDefaults.profile.unitFrames.boss.powerBar
ns.dbDefaults.profile.unitFrames.boss.powerBar.foreground = foregroundHandler.dbDefaults

ns.options.args.boss.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		for i, bbi in ipairs(BUFBoss.frames) do
			bbi.power.foreground = {}
			bbi.power.foreground.statusBar = bbi.manaBar
			bbi.power.foreground.maskTexture = bbi.manaBar.ManaBarMask
			bbi.power.foreground.unit = "boss" .. i
		end
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Party-PortraitOff-Bar-Mana-Mask"
	end
	self:RefreshStatusBarForegroundConfig()
end

function foregroundHandler:RefreshStatusBarTexture()
	local useCustomTexture = self:GetUseStatusBarTexture()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshStatusBarTexture(bbi.power.foreground.statusBar)
		if useCustomTexture then
			bbi.power.foreground.maskTexture:Hide()
		end
	end
end

function foregroundHandler:RefreshColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshColor(bbi.power.foreground.statusBar, bbi.power.foreground.unit)
	end
end

BUFBossPower.foregroundHandler = foregroundHandler
