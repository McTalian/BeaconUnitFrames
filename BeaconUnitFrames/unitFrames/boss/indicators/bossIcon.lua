---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Indicators
local BUFBossIndicators = ns.BUFBoss.Indicators

---@class BUFBoss.Indicators.BossIcon: BUFScaleTexture
local BUFBossBossIcon = {
	configPath = "unitFrames.boss.bossIcon",
}

BUFBossBossIcon.optionsTable = {
	type = "group",
	handler = BUFBossBossIcon,
	name = ns.L["Boss Icon"],
	order = BUFBossIndicators.optionsOrder.BOSS_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Boss.BossIcon
BUFBossBossIcon.dbDefaults = {
	anchorPoint = "CENTER",
	relativeTo = BUFBoss.relativeToFrames.PORTRAIT,
	relativePoint = "BOTTOM",
	xOffset = 0,
	yOffset = 0,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFBossBossIcon)
ns.Mixin(BUFBossBossIcon, ns.BUFBossPositionable)

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss
ns.dbDefaults.profile.unitFrames.boss.bossIcon = BUFBossBossIcon.dbDefaults

ns.options.args.boss.args.indicators.args.bossIcon = BUFBossBossIcon.optionsTable

function BUFBossBossIcon:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.indicators.bossIcon.texture)
	end
end

function BUFBossBossIcon:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.indicators.bossIcon = {}
			bbi.indicators.bossIcon.texture = bbi.contentContextual.BossIcon
			bbi.indicators.bossIcon.texture.bufOverrideParentFrame = bbi.frame
		end
	end
	self:RefreshScaleTextureConfig()
end

function BUFBossBossIcon:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.indicators.bossIcon.texture)
	end
end

function BUFBossBossIcon:SetScaleFactor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetScaleFactor(bbi.indicators.bossIcon.texture)
	end
end

BUFBossIndicators.BossIcon = BUFBossBossIcon
