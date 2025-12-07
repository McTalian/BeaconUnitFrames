---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Portrait: BUFFramePortrait
local BUFPetPortrait = {
	configPath = "unitFrames.pet.portrait",
	frameKey = BUFPet.relativeToFrames.PORTRAIT,
	module = BUFPet,
}

BUFPetPortrait.optionsTable = {
	type = "group",
	handler = BUFPetPortrait,
	name = ns.L["Portrait"],
	order = BUFPet.optionsOrder.PORTRAIT,
	args = {},
}

---@class BUFDbSchema.UF.Pet.Portrait
BUFPetPortrait.dbDefaults = {
	enabled = true,
	width = 37,
	height = 37,
	scale = 1,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPet.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 5,
	yOffset = -5,
	mask = "CircleMaskScalable",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

ns.BUFFramePortrait:ApplyMixin(BUFPetPortrait)

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet
ns.dbDefaults.profile.unitFrames.pet.portrait = BUFPetPortrait.dbDefaults

ns.options.args.pet.args.portrait = BUFPetPortrait.optionsTable

function BUFPetPortrait:RefreshConfig()
	if not self.initialized then
		BUFPet.FrameInit(self)

		self.texture = PetPortrait
		self.maskTexture = BUFPet.frame.PortraitMask
	end
	self:RefreshPortraitConfig()
end

BUFPet.Portrait = BUFPetPortrait
