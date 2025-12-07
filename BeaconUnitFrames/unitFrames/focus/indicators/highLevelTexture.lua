---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.HighLevelTexture: BUFScaleTexture
local BUFFocusHighLevelTexture = {
	configPath = "unitFrames.focus.highLevelTexture",
}

BUFFocusHighLevelTexture.optionsTable = {
	type = "group",
	handler = BUFFocusHighLevelTexture,
	name = ns.L["High Level Texture"],
	order = BUFFocusIndicators.optionsOrder.HIGH_LEVEL_TEXTURE,
	args = {},
}

---@class BUFDbSchema.UF.Focus.HighLevelTexture
BUFFocusHighLevelTexture.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFFocus.relativeToFrames.LEVEL,
	relativePoint = "TOPLEFT",
	xOffset = 4,
	yOffset = 2,
	useAtlasSize = true,
	width = 11,
	height = 14,
	scale = 1,
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusHighLevelTexture)

ns.options.args.focus.args.indicators.args.highLevelTexture = BUFFocusHighLevelTexture.optionsTable

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus

ns.dbDefaults.profile.unitFrames.focus.highLevelTexture = BUFFocusHighLevelTexture.dbDefaults

function BUFFocusHighLevelTexture:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.HighLevelTexture
	end
	self:RefreshScaleTextureConfig()
end

BUFFocusIndicators.HighLevelTexture = BUFFocusHighLevelTexture
