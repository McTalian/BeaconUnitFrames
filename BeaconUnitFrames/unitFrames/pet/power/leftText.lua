---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power
local BUFPetPower = BUFPet.Power

---@class BUFPet.Power.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.pet.powerBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFPetPower.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFPetPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Pet.Power
ns.dbDefaults.profile.unitFrames.pet.powerBar = ns.dbDefaults.profile.unitFrames.pet.powerBar

ns.dbDefaults.profile.unitFrames.pet.powerBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFPet.relativeToFrames.POWER,
	relativePoint = "LEFT",
	xOffset = 4,
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

ns.options.args.pet.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.customRelativeToOptions = BUFPet.customRelativeToOptions
		self.customRelativeToSorting = BUFPet.customRelativeToSorting

		self.fontString = PetFrameManaBarTextLeft
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end
