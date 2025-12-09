---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Indicators
local BUFBossIndicators = ns.BUFBoss.Indicators

---@class BUFBoss.Indicators.BossPortraitFrameTexture: BUFScaleTexture
local BUFBossBossPortraitFrameTexture = {
	configPath = "unitFrames.boss.bossPortraitFrameTexture",
}

BUFBossBossPortraitFrameTexture.optionsTable = {
	type = "group",
	handler = BUFBossBossPortraitFrameTexture,
	name = ns.L["Boss Portrait Frame Texture"],
	order = BUFBossIndicators.optionsOrder.BOSS_PORTRAIT_FRAME_TEXTURE,
	args = {},
}

---@class BUFDbSchema.UF.Boss.BossPortraitFrameTexture
BUFBossBossPortraitFrameTexture.dbDefaults = {
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFBoss.relativeToFrames.PORTRAIT,
	relativePoint = "TOPRIGHT",
	xOffset = -11,
	yOffset = -8,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFBossBossPortraitFrameTexture)
ns.Mixin(BUFBossBossPortraitFrameTexture, ns.BUFBossPositionable)

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss
ns.dbDefaults.profile.unitFrames.boss.bossPortraitFrameTexture = BUFBossBossPortraitFrameTexture.dbDefaults

ns.options.args.boss.args.indicators.args.bossPortraitFrameTexture = BUFBossBossPortraitFrameTexture.optionsTable

function BUFBossBossPortraitFrameTexture:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.indicators.bossPortraitFrameTexture.texture)
	end
end

function BUFBossBossPortraitFrameTexture:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.indicators.bossPortraitFrameTexture = {}
			bbi.indicators.bossPortraitFrameTexture.texture = bbi.container.BossPortraitFrameTexture
			bbi.indicators.bossPortraitFrameTexture.texture.bufOverrideParentFrame = bbi.frame

			if not BUFBoss:IsHooked(bbi.indicators.bossPortraitFrameTexture.texture, "Show") then
				BUFBoss:SecureHook(bbi.indicators.bossPortraitFrameTexture.texture, "Show", function()
					self:RefreshScaleTextureConfig()
				end)
			end
		end
	end
	self:RefreshScaleTextureConfig()
end

function BUFBossBossPortraitFrameTexture:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.indicators.bossPortraitFrameTexture.texture)
	end
end

function BUFBossBossPortraitFrameTexture:SetScaleFactor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetScaleFactor(bbi.indicators.bossPortraitFrameTexture.texture)
	end
end

BUFBossIndicators.BossPortraitFrameTexture = BUFBossBossPortraitFrameTexture
