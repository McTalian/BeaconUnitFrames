---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Health
local BUFPartyHealth = BUFParty.Health

---@class BUFParty.Health.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.party.healthBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFPartyHealth.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Party.Health.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 1, 0, 1 },
	useClassColor = false,
	useReactionColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, true, true, false)

---@class BUFDbSchema.UF.Party.Health
ns.dbDefaults.profile.unitFrames.party.healthBar = ns.dbDefaults.profile.unitFrames.party.healthBar
ns.dbDefaults.profile.unitFrames.party.healthBar.foreground = foregroundHandler.dbDefaults

ns.options.args.party.args.healthBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		for i, bpi in ipairs(BUFParty.frames) do
			bpi.health.foreground = {}
			bpi.health.foreground.statusBar = bpi.healthBar
			bpi.health.foreground.unit = "party" .. i
		end
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health"
	end
	self:RefreshStatusBarForegroundConfig()
end

function foregroundHandler:RefreshStatusBarTexture()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_RefreshStatusBarTexture(bpi.health.foreground.statusBar)
	end
end

function foregroundHandler:RefreshColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_RefreshColor(bpi.health.foreground.statusBar, bpi.health.foreground.unit)
	end
end

BUFPartyHealth.foregroundHandler = foregroundHandler
