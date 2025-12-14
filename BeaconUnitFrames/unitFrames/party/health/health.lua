---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Health: BUFStatusBar
local BUFPartyHealth = {
	configPath = "unitFrames.party.healthBar",
	frameKey = BUFParty.relativeToFrames.HEALTH,
}

BUFPartyHealth.optionsTable = {
	type = "group",
	handler = BUFPartyHealth,
	name = HEALTH,
	order = BUFParty.optionsOrder.HEALTH,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.Party
ns.dbDefaults.profile.unitFrames.party = ns.dbDefaults.profile.unitFrames.party

---@class BUFDbSchema.UF.Party.Health
ns.dbDefaults.profile.unitFrames.party.healthBar = {
	width = 70,
	height = 10,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFParty.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 45,
	yOffset = -19,
	frameLevel = 3,
}

local healthBarOrder = {}
ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.LEFT_TEXT = healthBarOrder.FRAME_LEVEL + 0.1
healthBarOrder.RIGHT_TEXT = healthBarOrder.LEFT_TEXT + 0.1
healthBarOrder.CENTER_TEXT = healthBarOrder.RIGHT_TEXT + 0.1
healthBarOrder.DEAD_TEXT = healthBarOrder.CENTER_TEXT + 0.1
healthBarOrder.UNCONSCIOUS_TEXT = healthBarOrder.DEAD_TEXT + 0.1
healthBarOrder.FOREGROUND = healthBarOrder.UNCONSCIOUS_TEXT + 0.1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + 0.1

BUFPartyHealth.topGroupOrder = healthBarOrder

ns.options.args.party.args.healthBar = BUFPartyHealth.optionsTable

ns.BUFStatusBar:ApplyMixin(BUFPartyHealth)
ns.Mixin(BUFPartyHealth, ns.BUFPartyPositionable)

function BUFPartyHealth:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bpi in ipairs(BUFParty.frames) do
			bpi.health = {}
			bpi.health.barOrContainer = bpi.healthBar
			bpi.health.barOrContainer.bufOverrideParentFrame = bpi.frame
		end
	end
	self:RefreshStatusBarConfig()
end

function BUFPartyHealth:SetSize()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetSize(bpi.health.barOrContainer)
	end
end

function BUFPartyHealth:SetPosition()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetPosition(bpi.health.barOrContainer)
	end
end

function BUFPartyHealth:SetLevel()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetLevel(bpi.health.barOrContainer)
	end
end

BUFParty.Health = BUFPartyHealth
