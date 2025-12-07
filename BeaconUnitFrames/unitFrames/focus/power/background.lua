---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Power
local BUFFocusPower = BUFFocus.Power

---@class BUFFocus.Power.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.focus.powerBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFFocusPower.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Focus.Power.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Focus.Power
ns.dbDefaults.profile.unitFrames.focus.powerBar = ns.dbDefaults.profile.unitFrames.focus.powerBar
ns.dbDefaults.profile.unitFrames.focus.powerBar.background = backgroundHandler.dbDefaults

ns.options.args.focus.args.powerBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFFocus.manaBar:CreateTexture("BUFFocusPowerBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFFocus.manaBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFFocusPower.backgroundHandler = backgroundHandler
