---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Power: BUFStatusBar
local BUFToTPower = {
	configPath = "unitFrames.tot.powerBar",
	frameKey = BUFToT.relativeToFrames.POWER,
}

BUFToTPower.optionsTable = {
	type = "group",
	handler = BUFToTPower,
	name = POWER_TYPE_POWER,
	order = BUFToT.optionsOrder.POWER,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.ToT.Power
BUFToTPower.dbDefaults = {
	width = 74,
	height = 7,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFToT.relativeToFrames.HEALTH,
	relativePoint = "BOTTOMLEFT",
	xOffset = -4,
	yOffset = -1,
	frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFToTPower)

BUFToT.Power = BUFToTPower

---@class BUFDbSchema.UF.ToT
ns.dbDefaults.profile.unitFrames.tot = ns.dbDefaults.profile.unitFrames.tot

ns.dbDefaults.profile.unitFrames.tot.powerBar = BUFToTPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.FOREGROUND = powerBarOrder.FRAME_LEVEL + 0.1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + 0.1

BUFToTPower.topGroupOrder = powerBarOrder

ns.options.args.tot.args.powerBar = BUFToTPower.optionsTable

function BUFToTPower:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.barOrContainer = BUFToT.manaBar
	end
	self:RefreshStatusBarConfig()
end
