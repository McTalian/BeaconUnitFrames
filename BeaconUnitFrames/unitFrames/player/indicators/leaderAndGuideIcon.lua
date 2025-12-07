---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.LeaderAndGuideIcon: BUFScaleTexture
local BUFPlayerLeaderAndGuideIcon = {
	configPath = "unitFrames.player.leaderAndGuideIcon",
}

BUFPlayerLeaderAndGuideIcon.optionsOrder = {}
ns.Mixin(BUFPlayerLeaderAndGuideIcon.optionsOrder, ns.defaultOrderMap)
BUFPlayerLeaderAndGuideIcon.optionsOrder.SEPARATE_GUIDE_STYLE = BUFPlayerLeaderAndGuideIcon.optionsOrder.Y_OFFSET + 0.1
BUFPlayerLeaderAndGuideIcon.optionsOrder.GUIDE = BUFPlayerLeaderAndGuideIcon.optionsOrder.SEPARATE_GUIDE_STYLE + 0.1

BUFPlayerLeaderAndGuideIcon.optionsTable = {
	type = "group",
	handler = BUFPlayerLeaderAndGuideIcon,
	name = ns.L["LeaderAndGuideIcon"],
	order = BUFPlayerIndicators.optionsOrder.LEADER_AND_GUIDE_ICON,
	args = {
		separateGuideStyle = {
			type = "toggle",
			name = ns.L["SeparateGuideStyle"],
			set = "SetUseSeparateGuideStyle",
			get = "GetUseSeparateGuideStyle",
			order = BUFPlayerLeaderAndGuideIcon.optionsOrder.SEPARATE_GUIDE_STYLE,
		},
	},
}

---@class BUFDbSchema.UF.Player.LeaderAndGuideIcon
BUFPlayerLeaderAndGuideIcon.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 86,
	yOffset = -10,
	scale = 1,
	separateGuideStyle = false,
	guide = {
		anchorPoint = "TOPLEFT",
		relativeTo = BUFPlayer.relativeToFrames.FRAME,
		relativePoint = "TOPLEFT",
		xOffset = 86,
		yOffset = -10,
		scale = 1,
	},
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerLeaderAndGuideIcon)

---@class BUFPlayer.LeaderAndGuideIcon.Guide: BUFScaleTexture
local Guide = {
	configPath = "unitFrames.player.leaderAndGuideIcon.guide",
}

Guide.optionsTable = {
	type = "group",
	handler = Guide,
	name = ns.L["GuideIcon"],
	hidden = Guide.IsHidden,
	inline = true,
	order = BUFPlayerLeaderAndGuideIcon.optionsOrder.GUIDE,
	args = {},
}

ns.BUFScaleTexture:ApplyMixin(Guide)

BUFPlayerLeaderAndGuideIcon.Guide = Guide
BUFPlayerLeaderAndGuideIcon.optionsTable.args.guide = Guide.optionsTable
BUFPlayerIndicators.LeaderAndGuideIcon = BUFPlayerLeaderAndGuideIcon

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.leaderAndGuideIcon = BUFPlayerLeaderAndGuideIcon.dbDefaults

ns.options.args.player.args.indicators.args.leaderAndGuideIcon = BUFPlayerLeaderAndGuideIcon.optionsTable

function Guide.IsHidden()
	return not BUFPlayerLeaderAndGuideIcon:GetUseSeparateGuideStyle()
end

function BUFPlayerLeaderAndGuideIcon:SetUseSeparateGuideStyle(info, value)
	self:DbSet("separateGuideStyle", value)
	self:SeparateLeaderAndGuideStyle()
end

function BUFPlayerLeaderAndGuideIcon:GetUseSeparateGuideStyle(info)
	return self:DbGet("separateGuideStyle")
end

function BUFPlayerLeaderAndGuideIcon:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.texture = BUFPlayer.contentContextual.LeaderIcon
	end
	if not Guide.initialized then
		Guide.initialized = true

		Guide.customRelativeToOptions = BUFPlayer.customRelativeToOptions
		Guide.customRelativeToSorting = BUFPlayer.customRelativeToSorting

		Guide.texture = BUFPlayer.contentContextual.GuideIcon
	end
	self:RefreshScaleTextureConfig()
	if self:DbGet("separateGuideStyle") then
		self.Guide:RefreshConfig()
	end
end

function BUFPlayerLeaderAndGuideIcon:SetPosition()
	self:_SetPosition(self.texture)

	if not self:DbGet("separateGuideStyle") then
		self.Guide:SetPosition()
	end
end

function BUFPlayerLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
	local isSeparated = self:DbGet("separateGuideStyle")
	if isSeparated then
		self.Guide:RefreshConfig()
	else
		self:RefreshConfig()
	end
end

function Guide:RefreshConfig()
	self:RefreshScaleTextureConfig()
end
