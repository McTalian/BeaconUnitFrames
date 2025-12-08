---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Health
local BUFToFocusHealth = BUFToFocus.Health

---@class BUFToFocus.Health.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.tofocus.healthBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFToFocusHealth.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.ToFocus.Health.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.ToFocus.Health
ns.dbDefaults.profile.unitFrames.tofocus.healthBar = ns.dbDefaults.profile.unitFrames.tofocus.healthBar
ns.dbDefaults.profile.unitFrames.tofocus.healthBar.background = backgroundHandler.dbDefaults

ns.options.args.tofocus.args.healthBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFToFocus.healthBar:CreateTexture("BUFToFocusHealthBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFToFocus.healthBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFToFocusHealth.backgroundHandler = backgroundHandler
