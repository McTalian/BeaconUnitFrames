---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Health: BUFStatusBar
local BUFFocusHealth = {
	configPath = "unitFrames.focus.healthBar",
	frameKey = BUFFocus.relativeToFrames.HEALTH,
}

BUFFocusHealth.optionsTable = {
	type = "group",
	handler = BUFFocusHealth,
	name = HEALTH,
	order = BUFFocus.optionsOrder.HEALTH,
	childGroups = "tree",
	args = {},
}

ns.BUFStatusBar:ApplyMixin(BUFFocusHealth)

BUFFocus.Health = BUFFocusHealth

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus

---@class BUFDbSchema.UF.Focus.Health
ns.dbDefaults.profile.unitFrames.focus.healthBar = {
	width = 126,
	height = 20,
	anchorPoint = "BOTTOMRIGHT",
	relativeTo = BUFFocus.relativeToFrames.FRAME,
	relativePoint = "LEFT",
	xOffset = 148,
	yOffset = 2,
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

BUFFocusHealth.topGroupOrder = healthBarOrder

ns.options.args.focus.args.healthBar = BUFFocusHealth.optionsTable

function BUFFocusHealth:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.barOrContainer = BUFFocus.healthBar
	end
	self:RefreshStatusBarConfig()
end
