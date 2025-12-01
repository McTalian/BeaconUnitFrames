---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Health: BUFStatusBar
local BUFPetHealth = {
	configPath = "unitFrames.pet.healthBar",
}

BUFPetHealth.optionsTable = {
	type = "group",
	handler = BUFPetHealth,
	name = HEALTH,
	order = BUFPet.optionsOrder.HEALTH,
	childGroups = "tree",
	args = {},
}

ns.BUFStatusBar:ApplyMixin(BUFPetHealth)

BUFPet.Health = BUFPetHealth

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

---@class BUFDbSchema.UF.Pet.Health
ns.dbDefaults.profile.unitFrames.pet.healthBar = {
	width = 70,
	height = 10,
	anchorPoint = "BOTTOMLEFT",
	relativeTo = ns.DEFAULT,
	relativePoint = "RIGHT",
	xOffset = 2,
	yOffset = -3.5,
	frameLevel = 3,
}

local healthBarOrder = {}

ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.LEFT_TEXT = healthBarOrder.FRAME_LEVEL + 0.1
healthBarOrder.RIGHT_TEXT = healthBarOrder.LEFT_TEXT + 0.1
healthBarOrder.CENTER_TEXT = healthBarOrder.RIGHT_TEXT + 0.1
healthBarOrder.FOREGROUND = healthBarOrder.CENTER_TEXT + 0.1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + 0.1

BUFPetHealth.topGroupOrder = healthBarOrder

ns.options.args.pet.args.healthBar = BUFPetHealth.optionsTable

function BUFPetHealth:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.defaultRelativeTo = PetPortrait

		self.barOrContainer = PetFrameHealthBar
	end
	self:RefreshStatusBarConfig()
end
