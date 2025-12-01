---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Indicators: BUFParentHandler
local BUFPetIndicators = {}

BUFPetIndicators.optionsTable = {
	type = "group",
	handler = BUFPetIndicators,
	name = ns.L["Indicators and Icons"],
	order = BUFPet.optionsOrder.INDICATORS,
	args = {},
}

BUFPetIndicators.optionsOrder = {
	HIT_INDICATOR = 1,
}

ns.options.args.pet.args.indicators = BUFPetIndicators.optionsTable

function BUFPetIndicators:RefreshConfig()
	self.HitIndicator:RefreshConfig()
end

BUFPet.Indicators = BUFPetIndicators
