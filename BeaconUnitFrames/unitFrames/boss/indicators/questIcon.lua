---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Indicators
local BUFBossIndicators = ns.BUFBoss.Indicators

---@class BUFBoss.Indicators.QuestIcon: BUFScaleTexture
local BUFBossQuestIcon = {
	configPath = "unitFrames.boss.questIcon",
}

BUFBossQuestIcon.optionsTable = {
	type = "group",
	handler = BUFBossQuestIcon,
	name = ns.L["Quest Icon"],
	order = BUFBossIndicators.optionsOrder.QUEST_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Boss.QuestIcon
BUFBossQuestIcon.dbDefaults = {
	anchorPoint = "CENTER",
	relativeTo = BUFBoss.relativeToFrames.PORTRAIT,
	relativePoint = "BOTTOM",
	xOffset = 0,
	yOffset = 0,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFBossQuestIcon)
ns.Mixin(BUFBossQuestIcon, ns.BUFBossPositionable)

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss
ns.dbDefaults.profile.unitFrames.boss.questIcon = BUFBossQuestIcon.dbDefaults

ns.options.args.boss.args.indicators.args.questIcon = BUFBossQuestIcon.optionsTable

function BUFBossQuestIcon:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bbi in ipairs(BUFBoss.frames) do
		if self.demoMode then
			bbi.indicators.questIcon.texture:Show()
		else
			bbi.indicators.questIcon.texture:Hide()
		end
	end
end

function BUFBossQuestIcon:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.indicators.questIcon = {}
			bbi.indicators.questIcon.texture = bbi.contentContextual.QuestIcon
			bbi.indicators.questIcon.texture.bufOverrideParentFrame = bbi.frame
		end
	end
	self:RefreshScaleTextureConfig()
end

function BUFBossQuestIcon:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.indicators.questIcon.texture)
	end
end

function BUFBossQuestIcon:SetScaleFactor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetScaleFactor(bbi.indicators.questIcon.texture)
	end
end

BUFBossIndicators.QuestIcon = BUFBossQuestIcon
