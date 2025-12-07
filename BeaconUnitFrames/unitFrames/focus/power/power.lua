---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Power: BUFStatusBar
local BUFFocusPower = {
	configPath = "unitFrames.focus.powerBar",
	frameKey = BUFFocus.relativeToFrames.POWER,
}

BUFFocusPower.optionsTable = {
	type = "group",
	handler = BUFFocusPower,
	name = POWER_TYPE_POWER,
	order = BUFFocus.optionsOrder.POWER,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.Focus.Power
BUFFocusPower.dbDefaults = {
	width = 134,
	height = 10,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFFocus.relativeToFrames.HEALTH,
	relativePoint = "BOTTOMRIGHT",
	xOffset = 8,
	yOffset = -1,
	frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFFocusPower)

BUFFocus.Power = BUFFocusPower

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus

ns.dbDefaults.profile.unitFrames.focus.powerBar = BUFFocusPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + 0.1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + 0.1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + 0.1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + 0.1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + 0.1

BUFFocusPower.topGroupOrder = powerBarOrder

ns.options.args.focus.args.powerBar = BUFFocusPower.optionsTable

function BUFFocusPower:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.barOrContainer = BUFFocus.manaBar
	end
	self:RefreshStatusBarConfig()
end
