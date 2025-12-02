---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.BossPortraitFrameTexture: BUFScaleTexture
local BUFTargetBossPortraitFrameTexture = {
	configPath = "unitFrames.target.bossPortraitFrameTexture",
}

BUFTargetBossPortraitFrameTexture.optionsTable = {
	type = "group",
	handler = BUFTargetBossPortraitFrameTexture,
	name = ns.L["Boss Portrait Frame Texture"],
	order = BUFTargetIndicators.optionsOrder.BOSS_PORTRAIT_FRAME_TEXTURE,
	args = {},
}

---@class BUFDbSchema.UF.Target.BossPortraitFrameTexture
BUFTargetBossPortraitFrameTexture.dbDefaults = {
	anchorPoint = "TOPRIGHT",
	relativeTo = ns.DEFAULT,
	relativePoint = "TOPRIGHT",
	xOffset = -11,
	yOffset = -8,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetBossPortraitFrameTexture)

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.bossPortraitFrameTexture = BUFTargetBossPortraitFrameTexture.dbDefaults

ns.options.args.target.args.indicators.args.bossPortraitFrameTexture = BUFTargetBossPortraitFrameTexture.optionsTable

function BUFTargetBossPortraitFrameTexture:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.texture = BUFTarget.container.BossPortraitFrameTexture
		self.defaultRelativeTo = BUFTarget.container

		if not BUFTarget:IsHooked(self.texture, "Show") then
			BUFTarget:SecureHook(self.texture, "Show", function()
				self:RefreshConfig()
			end)
		end
	end
	self:RefreshScaleTextureConfig()
end

BUFTargetIndicators.BossPortraitFrameTexture = BUFTargetBossPortraitFrameTexture
