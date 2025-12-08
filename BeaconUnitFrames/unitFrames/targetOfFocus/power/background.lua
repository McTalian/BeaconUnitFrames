---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Power
local BUFToFocusPower = BUFToFocus.Power

---@class BUFToFocus.Power.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.tofocus.powerBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFToFocusPower.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.ToFocus.Power.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.ToFocus.Power
ns.dbDefaults.profile.unitFrames.tofocus.powerBar = ns.dbDefaults.profile.unitFrames.tofocus.powerBar
ns.dbDefaults.profile.unitFrames.tofocus.powerBar.background = backgroundHandler.dbDefaults

ns.options.args.tofocus.args.powerBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFToFocus.manaBar:CreateTexture("BUFToFocusPowerBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFToFocus.manaBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFToFocusPower.backgroundHandler = backgroundHandler
