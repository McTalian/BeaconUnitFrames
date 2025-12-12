---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Indicators
local BUFBossIndicators = ns.BUFBoss.Indicators

---@class BUFBoss.Indicators.HighLevelTexture: BUFScaleTexture
local BUFBossHighLevelTexture = {
	configPath = "unitFrames.boss.highLevelTexture",
}

BUFBossHighLevelTexture.optionsTable = {
	type = "group",
	handler = BUFBossHighLevelTexture,
	name = ns.L["High Level Texture"],
	order = BUFBossIndicators.optionsOrder.HIGH_LEVEL_TEXTURE,
	args = {},
}

---@class BUFDbSchema.UF.Boss.HighLevelTexture
BUFBossHighLevelTexture.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFBoss.relativeToFrames.LEVEL,
	relativePoint = "TOPLEFT",
	xOffset = 4,
	yOffset = 2,
	useAtlasSize = true,
	width = 11,
	height = 14,
	scale = 1,
}

ns.BUFScaleTexture:ApplyMixin(BUFBossHighLevelTexture)
ns.Mixin(BUFBossHighLevelTexture, ns.BUFBossPositionable)

ns.options.args.boss.args.indicators.args.highLevelTexture = BUFBossHighLevelTexture.optionsTable

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss

ns.dbDefaults.profile.unitFrames.boss.highLevelTexture = BUFBossHighLevelTexture.dbDefaults

function BUFBossHighLevelTexture:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bbi in ipairs(BUFBoss.frames) do
		if self.demoMode then
			bbi.indicators.highLevelTexture.texture:Show()
		else
			bbi.indicators.highLevelTexture.texture:Hide()
		end
	end
end

function BUFBossHighLevelTexture:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.indicators.highLevelTexture = {}
			bbi.indicators.highLevelTexture.texture = bbi.contentContextual.HighLevelTexture
			bbi.indicators.highLevelTexture.texture.bufOverrideParentFrame = bbi.frame
		end
	end
	self:RefreshScaleTextureConfig()
end

function BUFBossHighLevelTexture:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.indicators.highLevelTexture.texture)
	end
end

function BUFBossHighLevelTexture:SetScaleFactor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetScaleFactor(bbi.indicators.highLevelTexture.texture)
	end
end

BUFBossIndicators.HighLevelTexture = BUFBossHighLevelTexture
