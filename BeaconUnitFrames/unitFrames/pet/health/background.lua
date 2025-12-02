---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Health
local BUFPetHealth = BUFPet.Health

---@class BUFPet.Health.Background: StatusBarBackground
local backgroundHandler = {
	configPath = "unitFrames.pet.healthBar.background",
}

backgroundHandler.optionsTable = {
	type = "group",
	handler = backgroundHandler,
	name = BACKGROUND,
	order = BUFPetHealth.topGroupOrder.BACKGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Pet.Health.Background
backgroundHandler.dbDefaults = {
	useBackgroundTexture = false,
	backgroundTexture = "None",
	customColor = { 0, 0, 0, 0 },
}

ns.StatusBarBackground:ApplyMixin(backgroundHandler)

---@class BUFDbSchema.UF.Pet.Health
ns.dbDefaults.profile.unitFrames.pet.healthBar = ns.dbDefaults.profile.unitFrames.pet.healthBar
ns.dbDefaults.profile.unitFrames.pet.healthBar.background = backgroundHandler.dbDefaults

ns.options.args.pet.args.healthBar.args.background = backgroundHandler.optionsTable

function backgroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.background = BUFPet.healthBar:CreateTexture("BUFPetHealthBarBackground", "BACKGROUND", nil, 2)
		self.background:SetAllPoints(BUFPet.healthBar)
	end
	self:RefreshStatusBarBackgroundConfig()
end

function backgroundHandler:RestoreDefaultBackgroundTexture()
	self.background:SetColorTexture(0, 0, 0, 0)
end

BUFPetHealth.backgroundHandler = backgroundHandler
