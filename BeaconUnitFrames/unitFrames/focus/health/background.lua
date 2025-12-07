---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Health
local BUFFocusHealth = BUFFocus.Health

---@class BUFFocus.Health.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.focus.healthBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFFocusHealth.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Focus.Health.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Focus.Health
ns.dbDefaults.profile.unitFrames.focus.healthBar = ns.dbDefaults.profile.unitFrames.focus.healthBar
ns.dbDefaults.profile.unitFrames.focus.healthBar.background = backgroundHandler.dbDefaults

ns.options.args.focus.args.healthBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFFocus.healthBar:CreateTexture("BUFFocusHealthBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFFocus.healthBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFFocusHealth.backgroundHandler = backgroundHandler
