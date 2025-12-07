---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.LeaderAndGuideIcon: BUFScaleTexture
local BUFTargetLeaderAndGuideIcon = {
	configPath = "unitFrames.target.leaderAndGuideIcon",
}

local leaderAndGuideIconOrder = {}
ns.Mixin(leaderAndGuideIconOrder, ns.defaultOrderMap)
leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE = leaderAndGuideIconOrder.Y_OFFSET + 0.1
leaderAndGuideIconOrder.GUIDE = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE + 0.1
BUFTargetLeaderAndGuideIcon.optionsOrder = leaderAndGuideIconOrder

BUFTargetLeaderAndGuideIcon.optionsTable = {
	type = "group",
	handler = BUFTargetLeaderAndGuideIcon,
	name = ns.L["LeaderAndGuideIcon"],
	order = BUFTargetIndicators.optionsOrder.LEADER_AND_GUIDE_ICON,
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

---@class BUFDbSchema.UF.Target.LeaderAndGuideIcon
BUFTargetLeaderAndGuideIcon.dbDefaults = {
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFTarget.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -85,
	yOffset = -8,
	scale = 1,
	separateGuideStyle = false,
	guide = {
		anchorPoint = "TOPRIGHT",
		relativeTo = BUFTarget.relativeToFrames.FRAME,
		relativePoint = "TOPRIGHT",
		xOffset = -85,
		yOffset = -8,
		scale = 1,
	},
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetLeaderAndGuideIcon)

---@class BUFTarget.LeaderAndGuideIcon.Guide: BUFScaleTexture
local Guide = {
	configPath = "unitFrames.target.leaderAndGuideIcon.guide",
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

BUFTargetLeaderAndGuideIcon.Guide = Guide
BUFTargetLeaderAndGuideIcon.optionsTable.args.guide = Guide.optionsTable
BUFTargetIndicators.LeaderAndGuideIcon = BUFTargetLeaderAndGuideIcon

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.leaderAndGuideIcon = BUFTargetLeaderAndGuideIcon.dbDefaults

ns.options.args.target.args.indicators.args.leaderAndGuideIcon = BUFTargetLeaderAndGuideIcon.optionsTable

function Guide.IsHidden()
	return not BUFTargetLeaderAndGuideIcon:GetUseSeparateGuideStyle()
end

function BUFTargetLeaderAndGuideIcon:SetUseSeparateGuideStyle(info, value)
	self:DbSet("separateGuideStyle", value)
	BUFTargetLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
end

function BUFTargetLeaderAndGuideIcon:GetUseSeparateGuideStyle(info)
	return self:DbGet("separateGuideStyle")
end

function BUFTargetLeaderAndGuideIcon:Initialize()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.texture = BUFTarget.contentContextual.LeaderIcon
	end
	self.Guide:Initialize()
end

function BUFTargetLeaderAndGuideIcon:RefreshConfig()
	self:Initialize()
	self:RefreshScaleTextureConfig()
	self.Guide:RefreshConfig()
end

function BUFTargetLeaderAndGuideIcon:SetPosition()
	self:_SetPosition(self.texture)

	if not self:GetUseSeparateGuideStyle() then
		self.Guide:SetPosition()
	end
end

function BUFTargetLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
	local isSeparated = self:GetUseSeparateGuideStyle()
	if isSeparated then
		self.Guide:RefreshConfig()
	else
		self:RefreshConfig()
	end
end

function Guide:Initialize()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.texture = BUFTarget.contentContextual.GuideIcon
	end
end

function Guide:RefreshConfig()
	if BUFTargetLeaderAndGuideIcon:GetUseSeparateGuideStyle() then
		self:RefreshScaleTextureConfig()
	end
end
