---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Health: BUFStatusBar
local BUFToFocusHealth = {
	configPath = "unitFrames.tofocus.healthBar",
	frameKey = BUFToFocus.relativeToFrames.HEALTH,
}

BUFToFocusHealth.optionsTable = {
	type = "group",
	handler = BUFToFocusHealth,
	name = HEALTH,
	order = BUFToFocus.optionsOrder.HEALTH,
	childGroups = "tree",
	args = {},
}

ns.BUFStatusBar:ApplyMixin(BUFToFocusHealth)

BUFToFocus.Health = BUFToFocusHealth

---@class BUFDbSchema.UF.ToFocus
ns.dbDefaults.profile.unitFrames.tofocus = ns.dbDefaults.profile.unitFrames.tofocus

---@class BUFDbSchema.UF.ToFocus.Health
ns.dbDefaults.profile.unitFrames.tofocus.healthBar = {
	width = 68,
	height = 10,
	anchorPoint = "BOTTOMRIGHT",
	relativeTo = BUFToFocus.relativeToFrames.FRAME,
	relativePoint = "RIGHT",
	xOffset = -6,
	yOffset = -2.5,
	frameLevel = 3,
}

local healthBarOrder = {}
ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.DEAD_TEXT = healthBarOrder.FRAME_LEVEL + 0.1
healthBarOrder.UNCONSCIOUS_TEXT = healthBarOrder.DEAD_TEXT + 0.1
healthBarOrder.FOREGROUND = healthBarOrder.UNCONSCIOUS_TEXT + 0.1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + 0.1

BUFToFocusHealth.topGroupOrder = healthBarOrder

ns.options.args.tofocus.args.healthBar = BUFToFocusHealth.optionsTable

function BUFToFocusHealth:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.barOrContainer = BUFToFocus.healthBar
	end
	self:RefreshStatusBarConfig()
end
