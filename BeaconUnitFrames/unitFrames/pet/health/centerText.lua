---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Health
local BUFPetHealth = BUFPet.Health

---@class BUFPet.Health.CenterText: BUFFontString
local centerTextHandler = {
	configPath = "unitFrames.pet.healthBar.centerText",
}

centerTextHandler.optionsTable = {
	type = "group",
	handler = centerTextHandler,
	name = ns.L["Center Text"],
	order = BUFPetHealth.topGroupOrder.CENTER_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(centerTextHandler)

BUFPetHealth.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Pet.Health
ns.dbDefaults.profile.unitFrames.pet.healthBar = ns.dbDefaults.profile.unitFrames.pet.healthBar

ns.dbDefaults.profile.unitFrames.pet.healthBar.centerText = {
	anchorPoint = "CENTER",
	relativeTo = BUFPet.relativeToFrames.HEALTH,
	relativePoint = "CENTER",
	xOffset = 0,
	yOffset = 0,
	useFontObjects = true,
	fontObject = "TextStatusBarText",
	fontColor = { 1, 1, 1, 1 },
	fontFace = "Friz Quadrata TT",
	fontSize = 10,
	fontFlags = {
		[ns.FontFlags.OUTLINE] = false,
		[ns.FontFlags.THICKOUTLINE] = false,
		[ns.FontFlags.MONOCHROME] = false,
	},
	fontShadowColor = { 0, 0, 0, 1 },
	fontShadowOffsetX = 1,
	fontShadowOffsetY = -1,
}

ns.options.args.pet.args.healthBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.customRelativeToOptions = BUFPet.customRelativeToOptions
		self.customRelativeToSorting = BUFPet.customRelativeToSorting

		self.fontString = PetFrameHealthBarText
		self.demoText = "123k / 123k"
	end
	self:RefreshFontStringConfig()
end
