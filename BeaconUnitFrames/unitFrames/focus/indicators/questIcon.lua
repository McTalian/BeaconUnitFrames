---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.QuestIcon: BUFScaleTexture
local BUFFocusQuestIcon = {
	configPath = "unitFrames.focus.questIcon",
}

BUFFocusQuestIcon.optionsTable = {
	type = "group",
	handler = BUFFocusQuestIcon,
	name = ns.L["Quest Icon"],
	order = BUFFocusIndicators.optionsOrder.QUEST_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Focus.QuestIcon
BUFFocusQuestIcon.dbDefaults = {
	anchorPoint = "CENTER",
	relativeTo = BUFFocus.relativeToFrames.PORTRAIT,
	relativePoint = "BOTTOM",
	xOffset = 0,
	yOffset = 0,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusQuestIcon)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.questIcon = BUFFocusQuestIcon.dbDefaults

ns.options.args.focus.args.indicators.args.questIcon = BUFFocusQuestIcon.optionsTable

function BUFFocusQuestIcon:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.QuestIcon
	end
	self:RefreshScaleTextureConfig()
end

BUFFocusIndicators.QuestIcon = BUFFocusQuestIcon
