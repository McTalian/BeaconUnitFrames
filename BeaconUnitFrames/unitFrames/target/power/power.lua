---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power: BUFStatusBar
local BUFTargetPower = {
	configPath = "unitFrames.target.powerBar",
	frameKey = BUFTarget.relativeToFrames.POWER,
}

BUFTargetPower.optionsTable = {
	type = "group",
	handler = BUFTargetPower,
	name = POWER_TYPE_POWER,
	order = BUFTarget.optionsOrder.POWER,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.Target.Power
BUFTargetPower.dbDefaults = {
	width = 134,
	height = 10,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFTarget.relativeToFrames.HEALTH,
	relativePoint = "BOTTOMRIGHT",
	xOffset = 8,
	yOffset = -1,
	frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFTargetPower)

BUFTarget.Power = BUFTargetPower

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

ns.dbDefaults.profile.unitFrames.target.powerBar = BUFTargetPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + 0.1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + 0.1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + 0.1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + 0.1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + 0.1

BUFTargetPower.topGroupOrder = powerBarOrder

ns.options.args.target.args.powerBar = BUFTargetPower.optionsTable

function BUFTargetPower:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.barOrContainer = BUFTarget.manaBar
	end
	self:RefreshStatusBarConfig()
end
