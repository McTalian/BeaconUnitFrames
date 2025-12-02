---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Health
local BUFTargetHealth = BUFTarget.Health

---@class BUFTarget.Health.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.target.healthBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFTargetHealth.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Target.Health.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Target.Health
ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar
ns.dbDefaults.profile.unitFrames.target.healthBar.background = backgroundHandler.dbDefaults

ns.options.args.target.args.healthBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFTarget.healthBar:CreateTexture("BUFTargetHealthBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFTarget.healthBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFTargetHealth.backgroundHandler = backgroundHandler
