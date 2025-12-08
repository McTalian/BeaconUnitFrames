---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Power
local BUFToTPower = BUFToT.Power

---@class BUFToT.Power.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.tot.powerBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFToTPower.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.ToT.Power.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.ToT.Power
ns.dbDefaults.profile.unitFrames.tot.powerBar = ns.dbDefaults.profile.unitFrames.tot.powerBar
ns.dbDefaults.profile.unitFrames.tot.powerBar.background = backgroundHandler.dbDefaults

ns.options.args.tot.args.powerBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFToT.manaBar:CreateTexture("BUFToTPowerBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFToT.manaBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFToTPower.backgroundHandler = backgroundHandler
