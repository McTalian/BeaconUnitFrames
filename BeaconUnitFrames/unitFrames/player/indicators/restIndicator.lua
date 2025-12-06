---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.RestIndicator: BUFScaleTexture
local BUFPlayerRestIndicator = {
	configPath = "unitFrames.player.restIndicator",
}

BUFPlayerRestIndicator.optionsTable = {
	type = "group",
	handler = BUFPlayerRestIndicator,
	name = ns.L["Rest Indicator"],
	order = BUFPlayerIndicators.optionsOrder.REST_INDICATOR,
	args = {},
}

---@class BUFDbSchema.UF.Player.RestIndicator
BUFPlayerRestIndicator.dbDefaults = {
	scale = 1.0,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 64,
	yOffset = -6,
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerRestIndicator)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.restIndicator = BUFPlayerRestIndicator.dbDefaults

ns.options.args.player.args.indicators.args.restIndicator = BUFPlayerRestIndicator.optionsTable

function BUFPlayerRestIndicator:ToggleDemoMode()
	self:_ToggleDemoMode(self.texture)
	if self.demoMode then
		self.texture.PlayerRestLoopAnim:Play()
	else
		self.texture.PlayerRestLoopAnim:Stop()
	end
end

function BUFPlayerRestIndicator:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.texture = BUFPlayer.contentContextual.PlayerRestLoop
	end
	self:RefreshScaleTextureConfig()
end

BUFPlayerIndicators.RestIndicator = BUFPlayerRestIndicator
