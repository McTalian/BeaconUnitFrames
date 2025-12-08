---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Power: BUFStatusBar
local BUFToFocusPower = {
	configPath = "unitFrames.tofocus.powerBar",
	frameKey = BUFToFocus.relativeToFrames.POWER,
}

BUFToFocusPower.optionsTable = {
	type = "group",
	handler = BUFToFocusPower,
	name = POWER_TYPE_POWER,
	order = BUFToFocus.optionsOrder.POWER,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.ToFocus.Power
BUFToFocusPower.dbDefaults = {
	width = 74,
	height = 7,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFToFocus.relativeToFrames.HEALTH,
	relativePoint = "BOTTOMLEFT",
	xOffset = -4,
	yOffset = -1,
	frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFToFocusPower)

BUFToFocus.Power = BUFToFocusPower

---@class BUFDbSchema.UF.ToFocus
ns.dbDefaults.profile.unitFrames.tofocus = ns.dbDefaults.profile.unitFrames.tofocus

ns.dbDefaults.profile.unitFrames.tofocus.powerBar = BUFToFocusPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.FOREGROUND = powerBarOrder.FRAME_LEVEL + 0.1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + 0.1

BUFToFocusPower.topGroupOrder = powerBarOrder

ns.options.args.tofocus.args.powerBar = BUFToFocusPower.optionsTable

function BUFToFocusPower:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.barOrContainer = BUFToFocus.manaBar
	end
	self:RefreshStatusBarConfig()
end
