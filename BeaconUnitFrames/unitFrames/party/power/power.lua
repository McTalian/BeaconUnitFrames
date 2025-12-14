---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Power: BUFStatusBar
local BUFPartyPower = {
	configPath = "unitFrames.party.powerBar",
	frameKey = BUFParty.relativeToFrames.POWER,
}

BUFPartyPower.optionsTable = {
	type = "group",
	handler = BUFPartyPower,
	name = POWER_TYPE_POWER,
	order = BUFParty.optionsOrder.POWER,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.Party.Power
BUFPartyPower.dbDefaults = {
	width = 74,
	height = 7,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFParty.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 41,
	yOffset = -30,
	frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFPartyPower)
ns.Mixin(BUFPartyPower, ns.BUFPartyPositionable)

BUFParty.Power = BUFPartyPower

---@class BUFDbSchema.UF.Party
ns.dbDefaults.profile.unitFrames.party = ns.dbDefaults.profile.unitFrames.party

ns.dbDefaults.profile.unitFrames.party.powerBar = BUFPartyPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + 0.1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + 0.1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + 0.1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + 0.1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + 0.1

BUFPartyPower.topGroupOrder = powerBarOrder

ns.options.args.party.args.powerBar = BUFPartyPower.optionsTable

function BUFPartyPower:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bpi in ipairs(BUFParty.frames) do
			bpi.power = {}
			bpi.power.barOrContainer = bpi.manaBar
			bpi.power.barOrContainer.bufOverrideParentFrame = bpi.frame
		end
	end
	self:RefreshStatusBarConfig()
end

function BUFPartyPower:SetSize()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetSize(bpi.power.barOrContainer)
	end
end

function BUFPartyPower:SetPosition()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetPosition(bpi.power.barOrContainer)
	end
end

function BUFPartyPower:SetLevel()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetLevel(bpi.power.barOrContainer)
	end
end
