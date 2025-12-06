---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power: BUFStatusBar
local BUFPetPower = {
	configPath = "unitFrames.pet.powerBar",
}

BUFPetPower.optionsTable = {
	type = "group",
	handler = BUFPetPower,
	name = POWER_TYPE_POWER,
	order = BUFPet.optionsOrder.POWER,
	childGroups = "tree",
	args = {},
}

ns.BUFStatusBar:ApplyMixin(BUFPetPower)

---@class BUFDbSchema.UF.Pet.Power
BUFPetPower.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPet.relativeToFrames.HEALTH,
	relativePoint = "BOTTOMLEFT",
	width = 74,
	height = 7,
	xOffset = -4,
	yOffset = -1,
	frameLevel = 3,
}

BUFPet.Power = BUFPetPower

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

ns.dbDefaults.profile.unitFrames.pet.powerBar = BUFPetPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + 0.1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + 0.1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + 0.1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + 0.1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + 0.1

BUFPetPower.topGroupOrder = powerBarOrder

ns.options.args.pet.args.powerBar = BUFPetPower.optionsTable

function BUFPetPower:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.customRelativeToOptions = BUFPET.customRelativeToOptions
		self.customRelativeToSorting = BUFPET.customRelativeToSorting

		self.barOrContainer = PetFrameManaBar
	end
	self:RefreshStatusBarConfig()
end
