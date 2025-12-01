---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.HighLevelTexture: BUFScaleTexture
local BUFTargetHighLevelTexture = {
	configPath = "unitFrames.target.highLevelTexture",
}

BUFTargetHighLevelTexture.optionsTable = {
	type = "group",
	handler = BUFTargetHighLevelTexture,
	name = ns.L["High Level Texture"],
	order = BUFTargetIndicators.optionsOrder.HIGH_LEVEL_TEXTURE,
	args = {},
}

---@class BUFDbSchema.UF.Target.HighLevelTexture
BUFTargetHighLevelTexture.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = ns.DEFAULT,
	relativePoint = "TOPLEFT",
	xOffset = 4,
	yOffset = 2,
	useAtlasSize = true,
	width = 11,
	height = 14,
	scale = 1,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetHighLevelTexture)

ns.options.args.target.args.indicators.args.highLevelTexture = BUFTargetHighLevelTexture.optionsTable

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

ns.dbDefaults.profile.unitFrames.target.highLevelTexture = BUFTargetHighLevelTexture.dbDefaults

function BUFTargetHighLevelTexture:RefreshConfig()
	if not self.texture then
		self.texture = BUFTarget.contentContextual.HighLevelTexture
		self.defaultRelativeTo = BUFTarget.contentMain.LevelText
	end
	self:RefreshScaleTextureConfig()
end

BUFTargetIndicators.HighLevelTexture = BUFTargetHighLevelTexture
