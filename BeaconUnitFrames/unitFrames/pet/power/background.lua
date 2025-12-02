---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power
local BUFPetPower = BUFPet.Power

---@class BUFPet.Power.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.pet.powerBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFPetPower.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Pet.Power.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Pet.Power
ns.dbDefaults.profile.unitFrames.pet.powerBar = ns.dbDefaults.profile.unitFrames.pet.powerBar
ns.dbDefaults.profile.unitFrames.pet.powerBar.background = backgroundHandler.dbDefaults

ns.options.args.pet.args.powerBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFPet.manaBar:CreateTexture("BUFPetPowerBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFPet.manaBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFPetPower.backgroundHandler = backgroundHandler
