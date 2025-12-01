---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power
local BUFPetPower = BUFPet.Power

---@class BUFPet.Power.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.pet.powerBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFPetPower.topGroupOrder.FOREGROUND,
	args = {},
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.Pet.Power
ns.dbDefaults.profile.unitFrames.pet.powerBar = ns.dbDefaults.profile.unitFrames.pet.powerBar

ns.dbDefaults.profile.unitFrames.pet.powerBar.foreground = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

ns.options.args.pet.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.unit = "pet"
		self.statusBar = PetFrameManaBar
	end
	self:RefreshStatusBarForegroundConfig()
end

BUFPetPower.foregroundHandler = foregroundHandler
