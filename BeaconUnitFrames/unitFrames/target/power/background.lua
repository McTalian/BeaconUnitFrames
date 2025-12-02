---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.target.powerBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFTargetPower.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Target.Power.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar
ns.dbDefaults.profile.unitFrames.target.powerBar.background = backgroundHandler.dbDefaults

ns.options.args.target.args.powerBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFTarget.manaBar:CreateTexture("BUFTargetPowerBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFTarget.manaBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFTargetPower.backgroundHandler = backgroundHandler
