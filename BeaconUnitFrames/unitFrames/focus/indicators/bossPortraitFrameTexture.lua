---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.BossPortraitFrameTexture: BUFScaleTexture
local BUFFocusBossPortraitFrameTexture = {
	configPath = "unitFrames.focus.bossPortraitFrameTexture",
}

BUFFocusBossPortraitFrameTexture.optionsTable = {
	type = "group",
	handler = BUFFocusBossPortraitFrameTexture,
	name = ns.L["Boss Portrait Frame Texture"],
	order = BUFFocusIndicators.optionsOrder.BOSS_PORTRAIT_FRAME_TEXTURE,
	args = {},
}

---@class BUFDbSchema.UF.Focus.BossPortraitFrameTexture
BUFFocusBossPortraitFrameTexture.dbDefaults = {
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFFocus.relativeToFrames.PORTRAIT,
	relativePoint = "TOPRIGHT",
	xOffset = -11,
	yOffset = -8,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusBossPortraitFrameTexture)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.bossPortraitFrameTexture = BUFFocusBossPortraitFrameTexture.dbDefaults

ns.options.args.focus.args.indicators.args.bossPortraitFrameTexture = BUFFocusBossPortraitFrameTexture.optionsTable

function BUFFocusBossPortraitFrameTexture:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.container.BossPortraitFrameTexture

		if not BUFFocus:IsHooked(self.texture, "Show") then
			BUFFocus:SecureHook(self.texture, "Show", function()
				self:RefreshConfig()
			end)
		end
	end
	self:RefreshScaleTextureConfig()
end

BUFFocusIndicators.BossPortraitFrameTexture = BUFFocusBossPortraitFrameTexture
