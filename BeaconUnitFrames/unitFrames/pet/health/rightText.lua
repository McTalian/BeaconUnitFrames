---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Health
local BUFPetHealth = BUFPet.Health

---@class BUFPet.Health.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.pet.healthBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFPetHealth.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)

BUFPetHealth.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Pet.Health
ns.dbDefaults.profile.unitFrames.pet.healthBar = ns.dbDefaults.profile.unitFrames.pet.healthBar

ns.dbDefaults.profile.unitFrames.pet.healthBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFPet.relativeToFrames.HEALTH,
	relativePoint = "RIGHT",
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

ns.options.args.pet.args.healthBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.customRelativeToOptions = BUFPet.customRelativeToOptions
		self.customRelativeToSorting = BUFPet.customRelativeToSorting

		self.fontString = PetFrameHealthBarTextRight
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end
