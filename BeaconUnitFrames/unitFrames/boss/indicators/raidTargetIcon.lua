---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Indicators
local BUFBossIndicators = ns.BUFBoss.Indicators

---@class BUFBoss.Indicators.RaidTargetIcon: BUFScaleTexture
local BUFBossRaidTargetIcon = {
	configPath = "unitFrames.boss.raidTargetIcon",
}

BUFBossRaidTargetIcon.optionsTable = {
	type = "group",
	handler = BUFBossRaidTargetIcon,
	name = ns.L["Raid Target Icon"],
	order = BUFBossIndicators.optionsOrder.RAID_TARGET_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Boss.RaidTargetIcon
BUFBossRaidTargetIcon.dbDefaults = {
	scale = 1,
	anchorPoint = "CENTER",
	relativeTo = BUFBoss.relativeToFrames.PORTRAIT,
	relativePoint = "TOP",
	xOffset = 0,
	yOffset = 0,
}

ns.BUFScaleTexture:ApplyMixin(BUFBossRaidTargetIcon)
ns.Mixin(BUFBossRaidTargetIcon, ns.BUFBossPositionable)

ns.options.args.boss.args.indicators.args.raidTargetIcon = BUFBossRaidTargetIcon.optionsTable

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss
ns.dbDefaults.profile.unitFrames.boss.raidTargetIcon = BUFBossRaidTargetIcon.dbDefaults

function BUFBossRaidTargetIcon:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.indicators.raidTargetIcon.texture)
	end
end

function BUFBossRaidTargetIcon:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.indicators.raidTargetIcon = {}
			bbi.indicators.raidTargetIcon.texture = bbi.contentContextual.RaidTargetIcon
			bbi.indicators.raidTargetIcon.texture.bufOverrideParentFrame = bbi.frame
		end
	end

	self:RefreshScaleTextureConfig()
end

function BUFBossRaidTargetIcon:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.indicators.raidTargetIcon.texture)
	end
end

function BUFBossRaidTargetIcon:SetScaleFactor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetScaleFactor(bbi.indicators.raidTargetIcon.texture)
	end
end

BUFBossIndicators.RaidTargetIcon = BUFBossRaidTargetIcon
