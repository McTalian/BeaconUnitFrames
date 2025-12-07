---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.PetBattleIcon: BUFScaleTexture
local BUFFocusPetBattleIcon = {
	configPath = "unitFrames.focus.petBattleIcon",
}

BUFFocusPetBattleIcon.optionsTable = {
	type = "group",
	handler = BUFFocusPetBattleIcon,
	name = ns.L["Pet Battle Icon"],
	order = BUFFocusIndicators.optionsOrder.PET_BATTLE_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Focus.PetBattleIcon
BUFFocusPetBattleIcon.dbDefaults = {
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFFocus.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -13,
	yOffset = -52,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusPetBattleIcon)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.petBattleIcon = BUFFocusPetBattleIcon.dbDefaults

ns.options.args.focus.args.indicators.args.petBattleIcon = BUFFocusPetBattleIcon.optionsTable

function BUFFocusPetBattleIcon:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.PetBattleIcon
	end
	self:RefreshScaleTextureConfig()
end

BUFFocusIndicators.PetBattleIcon = BUFFocusPetBattleIcon
