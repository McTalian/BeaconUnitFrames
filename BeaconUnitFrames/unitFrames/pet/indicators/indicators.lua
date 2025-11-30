---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Indicators: BUFConfigHandler
local BUFPetIndicators = {}


BUFPetIndicators.optionsOrder = {
  HIT_INDICATOR = 1,
}

local indicators = {
    type = "group",
    name = ns.L["Indicators and Icons"],
    order = BUFPet.optionsOrder.INDICATORS,
    childGroups = "tree",
    args = {},
}

ns.options.args.unitFrames.args.pet.args.indicators = indicators

function BUFPetIndicators:RefreshConfig()
  self.HitIndicator:RefreshConfig()
end

BUFPet.Indicators = BUFPetIndicators
