---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Power
local BUFPartyPower = BUFParty.Power

---@class BUFParty.Power.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.party.powerBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFPartyPower.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Party.Power.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Party.Power
ns.dbDefaults.profile.unitFrames.party.powerBar = ns.dbDefaults.profile.unitFrames.party.powerBar
ns.dbDefaults.profile.unitFrames.party.powerBar.background = backgroundHandler.dbDefaults

ns.options.args.party.args.powerBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		for i, bpi in ipairs(BUFParty.frames) do
			bpi.power.background =
				bpi.manaBar:CreateTexture("BUFParty" .. i .. "PowerBarBackground", "BACKGROUND", nil, 2)
			bpi.power.background:SetAllPoints(bpi.manaBar)
		end
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RefreshBackgroundTexture()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_RefreshBackgroundTexture(bpi.power.background)
	end
end

function backgroundHandler:RefreshColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_RefreshColor(bpi.power.background)
	end
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	for _, bpi in ipairs(BUFParty.frames) do
		bpi.power.background:SetColorTexture(0, 0, 0, 0)
	end
end

BUFPartyPower.backgroundHandler = backgroundHandler
