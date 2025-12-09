---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Power: BUFStatusBar
local BUFBossPower = {
	configPath = "unitFrames.boss.powerBar",
	frameKey = BUFBoss.relativeToFrames.POWER,
}

BUFBossPower.optionsTable = {
	type = "group",
	handler = BUFBossPower,
	name = POWER_TYPE_POWER,
	order = BUFBoss.optionsOrder.POWER,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.Boss.Power
BUFBossPower.dbDefaults = {
	width = 134,
	height = 10,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFBoss.relativeToFrames.HEALTH,
	relativePoint = "BOTTOMRIGHT",
	xOffset = 8,
	yOffset = -1,
	frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFBossPower)
ns.Mixin(BUFBossPower, ns.BUFBossPositionable)

BUFBoss.Power = BUFBossPower

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss

ns.dbDefaults.profile.unitFrames.boss.powerBar = BUFBossPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + 0.1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + 0.1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + 0.1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + 0.1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + 0.1

BUFBossPower.topGroupOrder = powerBarOrder

ns.options.args.boss.args.powerBar = BUFBossPower.optionsTable

function BUFBossPower:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.power = {}
			bbi.power.barOrContainer = bbi.manaBar
			bbi.power.barOrContainer.bufOverrideParentFrame = bbi.frame
		end
	end
	self:RefreshStatusBarConfig()
end

function BUFBossPower:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.power.barOrContainer)
	end
end

function BUFBossPower:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.power.barOrContainer)
	end
end

function BUFBossPower:SetLevel()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetLevel(bbi.power.barOrContainer)
	end
end
