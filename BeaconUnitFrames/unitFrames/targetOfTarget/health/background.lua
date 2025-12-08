---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Health
local BUFToTHealth = BUFToT.Health

---@class BUFToT.Health.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.tot.healthBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFToTHealth.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.ToT.Health.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.ToT.Health
ns.dbDefaults.profile.unitFrames.tot.healthBar = ns.dbDefaults.profile.unitFrames.tot.healthBar
ns.dbDefaults.profile.unitFrames.tot.healthBar.background = backgroundHandler.dbDefaults

ns.options.args.tot.args.healthBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFToT.healthBar:CreateTexture("BUFToTHealthBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFToT.healthBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFToTHealth.backgroundHandler = backgroundHandler
