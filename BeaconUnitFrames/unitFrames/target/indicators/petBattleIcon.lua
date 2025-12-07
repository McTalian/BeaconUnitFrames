---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.PetBattleIcon: BUFScaleTexture
local BUFTargetPetBattleIcon = {
	configPath = "unitFrames.target.petBattleIcon",
}

BUFTargetPetBattleIcon.optionsTable = {
	type = "group",
	handler = BUFTargetPetBattleIcon,
	name = ns.L["Pet Battle Icon"],
	order = BUFTargetIndicators.optionsOrder.PET_BATTLE_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Target.PetBattleIcon
BUFTargetPetBattleIcon.dbDefaults = {
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFTarget.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -13,
	yOffset = -52,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetPetBattleIcon)

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.petBattleIcon = BUFTargetPetBattleIcon.dbDefaults

ns.options.args.target.args.indicators.args.petBattleIcon = BUFTargetPetBattleIcon.optionsTable

function BUFTargetPetBattleIcon:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.texture = BUFTarget.contentContextual.PetBattleIcon
	end
	self:RefreshScaleTextureConfig()
end

BUFTargetIndicators.PetBattleIcon = BUFTargetPetBattleIcon
