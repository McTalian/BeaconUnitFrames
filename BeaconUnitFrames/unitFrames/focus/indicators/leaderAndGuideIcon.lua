---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.LeaderAndGuideIcon: BUFScaleTexture
local BUFFocusLeaderAndGuideIcon = {
	configPath = "unitFrames.focus.leaderAndGuideIcon",
}

local leaderAndGuideIconOrder = {}
ns.Mixin(leaderAndGuideIconOrder, ns.defaultOrderMap)
leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE = leaderAndGuideIconOrder.Y_OFFSET + 0.1
leaderAndGuideIconOrder.GUIDE = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE + 0.1
BUFFocusLeaderAndGuideIcon.optionsOrder = leaderAndGuideIconOrder

BUFFocusLeaderAndGuideIcon.optionsTable = {
	type = "group",
	handler = BUFFocusLeaderAndGuideIcon,
	name = ns.L["LeaderAndGuideIcon"],
	order = BUFFocusIndicators.optionsOrder.LEADER_AND_GUIDE_ICON,
	args = {
		separateGuideStyle = {
			type = "toggle",
			name = ns.L["SeparateGuideStyle"],
			set = "SetUseSeparateGuideStyle",
			get = "GetUseSeparateGuideStyle",
			order = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE,
		},
	},
}

---@class BUFDbSchema.UF.Focus.LeaderAndGuideIcon
BUFFocusLeaderAndGuideIcon.dbDefaults = {
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFFocus.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -85,
	yOffset = -8,
	scale = 1,
	separateGuideStyle = false,
	guide = {
		anchorPoint = "TOPRIGHT",
		relativeTo = BUFFocus.relativeToFrames.FRAME,
		relativePoint = "TOPRIGHT",
		xOffset = -85,
		yOffset = -8,
		scale = 1,
	},
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusLeaderAndGuideIcon)

---@class BUFFocus.LeaderAndGuideIcon.Guide: BUFScaleTexture
local Guide = {
	configPath = "unitFrames.focus.leaderAndGuideIcon.guide",
}

Guide.optionsTable = {
	type = "group",
	handler = Guide,
	name = ns.L["GuideIcon"],
	hidden = Guide.IsHidden,
	inline = true,
	order = leaderAndGuideIconOrder.GUIDE,
	args = {},
}

ns.BUFScaleTexture:ApplyMixin(Guide)

BUFFocusLeaderAndGuideIcon.Guide = Guide
BUFFocusLeaderAndGuideIcon.optionsTable.args.guide = Guide.optionsTable
BUFFocusIndicators.LeaderAndGuideIcon = BUFFocusLeaderAndGuideIcon

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.leaderAndGuideIcon = BUFFocusLeaderAndGuideIcon.dbDefaults

ns.options.args.focus.args.indicators.args.leaderAndGuideIcon = BUFFocusLeaderAndGuideIcon.optionsTable

function Guide.IsHidden()
	return not BUFFocusLeaderAndGuideIcon:GetUseSeparateGuideStyle()
end

function BUFFocusLeaderAndGuideIcon:SetUseSeparateGuideStyle(info, value)
	self:DbSet("separateGuideStyle", value)
	BUFFocusLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
end

function BUFFocusLeaderAndGuideIcon:GetUseSeparateGuideStyle(info)
	return self:DbGet("separateGuideStyle")
end

function BUFFocusLeaderAndGuideIcon:Initialize()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.LeaderIcon
	end
	self.Guide:Initialize()
end

function BUFFocusLeaderAndGuideIcon:RefreshConfig()
	self:Initialize()
	self:RefreshScaleTextureConfig()
	self.Guide:RefreshConfig()
end

function BUFFocusLeaderAndGuideIcon:SetPosition()
	self:_SetPosition(self.texture)

	if not self:GetUseSeparateGuideStyle() then
		self.Guide:SetPosition()
	end
end

function BUFFocusLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
	local isSeparated = self:GetUseSeparateGuideStyle()
	if isSeparated then
		self.Guide:RefreshConfig()
	else
		self:RefreshConfig()
	end
end

function Guide:Initialize()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.GuideIcon
	end
end

function Guide:RefreshConfig()
	if BUFFocusLeaderAndGuideIcon:GetUseSeparateGuideStyle() then
		self:RefreshScaleTextureConfig()
	end
end
