---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.QuestIcon: BUFScaleTexture
local BUFTargetQuestIcon = {
	configPath = "unitFrames.target.questIcon",
}

BUFTargetQuestIcon.optionsTable = {
	type = "group",
	handler = BUFTargetQuestIcon,
	name = ns.L["Quest Icon"],
	order = BUFTargetIndicators.optionsOrder.QUEST_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Target.QuestIcon
BUFTargetQuestIcon.dbDefaults = {
	anchorPoint = "CENTER",
	relativeTo = BUFTarget.relativeToFrames.PORTRAIT,
	relativePoint = "BOTTOM",
	xOffset = 0,
	yOffset = 0,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetQuestIcon)

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.questIcon = BUFTargetQuestIcon.dbDefaults

ns.options.args.target.args.indicators.args.questIcon = BUFTargetQuestIcon.optionsTable

function BUFTargetQuestIcon:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.texture = BUFTarget.contentContextual.QuestIcon
	end
	self:RefreshScaleTextureConfig()
end

BUFTargetIndicators.QuestIcon = BUFTargetQuestIcon
