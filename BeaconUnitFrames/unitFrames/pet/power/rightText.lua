---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power
local BUFPetPower = BUFPet.Power

---@class BUFPet.Power.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.pet.powerBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFPetPower.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)

BUFPetPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Pet.Power
ns.dbDefaults.profile.unitFrames.pet.powerBar = ns.dbDefaults.profile.unitFrames.pet.powerBar

ns.dbDefaults.profile.unitFrames.pet.powerBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFPet.relativeToFrames.POWER,
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

ns.options.args.pet.args.powerBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFPet.FrameInit(self)

		self.fontString = PetFrameManaBarTextRight
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end
