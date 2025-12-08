---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Health: BUFStatusBar
local BUFToTHealth = {
	configPath = "unitFrames.tot.healthBar",
	frameKey = BUFToT.relativeToFrames.HEALTH,
}

BUFToTHealth.optionsTable = {
	type = "group",
	handler = BUFToTHealth,
	name = HEALTH,
	order = BUFToT.optionsOrder.HEALTH,
	childGroups = "tree",
	args = {},
}

ns.BUFStatusBar:ApplyMixin(BUFToTHealth)

BUFToT.Health = BUFToTHealth

---@class BUFDbSchema.UF.ToT
ns.dbDefaults.profile.unitFrames.tot = ns.dbDefaults.profile.unitFrames.tot

---@class BUFDbSchema.UF.ToT.Health
ns.dbDefaults.profile.unitFrames.tot.healthBar = {
	width = 68,
	height = 10,
	anchorPoint = "BOTTOMRIGHT",
	relativeTo = BUFToT.relativeToFrames.FRAME,
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

BUFToTHealth.topGroupOrder = healthBarOrder

ns.options.args.tot.args.healthBar = BUFToTHealth.optionsTable

function BUFToTHealth:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.barOrContainer = BUFToT.healthBar
	end
	self:RefreshStatusBarConfig()
end
