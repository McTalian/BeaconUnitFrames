---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Power
local BUFBossPower = BUFBoss.Power

---@class BUFBoss.Power.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.boss.powerBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFBossPower.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Boss.Power.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Boss.Power
ns.dbDefaults.profile.unitFrames.boss.powerBar = ns.dbDefaults.profile.unitFrames.boss.powerBar
ns.dbDefaults.profile.unitFrames.boss.powerBar.background = backgroundHandler.dbDefaults

ns.options.args.boss.args.powerBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		for i, bbi in ipairs(BUFBoss.frames) do
			bbi.power.background =
				bbi.manaBar:CreateTexture("BUFBoss" .. i .. "PowerBarBackground", "BACKGROUND", nil, 2)
			bbi.power.background:SetAllPoints(bbi.manaBar)
		end
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RefreshBackgroundTexture()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshBackgroundTexture(bbi.power.background)
	end
end

function backgroundHandler:RefreshColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshColor(bbi.power.background)
	end
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	for _, bbi in ipairs(BUFBoss.frames) do
		bbi.power.background:SetColorTexture(0, 0, 0, 0)
	end
end

BUFBossPower.backgroundHandler = backgroundHandler
