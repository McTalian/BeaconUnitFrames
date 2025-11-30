---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Name: BUFConfigHandler, BUFFontString
local BUFPetName = {
    configPath = "unitFrames.pet.name",
}

BUFPetName.optionsTable = {
    type = "group",
    handler = BUFPetName,
    name = ns.L["Pet Name"],
    order = BUFPet.optionsOrder.NAME,
    args = {}
}

ns.BUFFontString:ApplyMixin(BUFPetName)

BUFPet.Name = BUFPetName

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

---@class BUFDbSchema.UF.Pet.Name
ns.dbDefaults.profile.unitFrames.pet.name = {
    width = 68,
    height = 10,
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 2,
    yOffset = 0,
    useFontObjects = true,
    fontObject = "GameFontNormalSmall",
    fontColor = { NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.a },
    fontFace = "Friz Quadrata TT",
    fontSize = 12,
    fontFlags = {
		[ns.FontFlags.OUTLINE] = false,
		[ns.FontFlags.THICKOUTLINE] = false,
		[ns.FontFlags.MONOCHROME] = false,
	},
	fontShadowColor = { 0, 0, 0, 1 },
	fontShadowOffsetX = 1,
	fontShadowOffsetY = -1,
    justifyH = "LEFT",
    justifyV = "BOTTOM",
}

ns.options.args.pet.args.petName = BUFPetName.optionsTable

function BUFPetName:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        self.fontString = PetName
        self.defaultRelativeTo = PetPortrait
        self.defaultRelativePoint = "TOPRIGHT"
    end
    self:RefreshFontStringConfig()
end
