---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.ReadyCheckIndicator: BUFScaleTexture
local BUFPlayerReadyCheckIndicator = {
	configPath = "unitFrames.player.readyCheckIndicator",
}

BUFPlayerReadyCheckIndicator.optionsTable = {
	type = "group",
	handler = BUFPlayerReadyCheckIndicator,
	name = ns.L["Ready Check Indicator"],
	order = BUFPlayerIndicators.optionsOrder.READY_CHECK_INDICATOR,
	args = {},
}

---@class BUFDbSchema.UF.Player.ReadyCheckIndicator
BUFPlayerReadyCheckIndicator.dbDefaults = {
	scale = 1.0,
	anchorPoint = "CENTER",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "CENTER",
	xOffset = 0,
	yOffset = 0,
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerReadyCheckIndicator)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.readyCheckIndicator = BUFPlayerReadyCheckIndicator.dbDefaults

ns.options.args.player.args.indicators.args.readyCheckIndicator = BUFPlayerReadyCheckIndicator.optionsTable

function BUFPlayerReadyCheckIndicator:ToggleDemoMode()
	self:_ToggleDemoMode(self.texture)
	if self.demoMode then
		self.texture.Texture:SetAtlas(READY_CHECK_READY_TEXTURE)
	end
end

function BUFPlayerReadyCheckIndicator:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.texture = BUFPlayer.contentContextual.ReadyCheck
	end
	self:RefreshScaleTextureConfig()
end

BUFPlayerIndicators.ReadyCheckIndicator = BUFPlayerReadyCheckIndicator
