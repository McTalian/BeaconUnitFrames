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

local leaderAndGuideIconOrder = {}
ns.Mixin(leaderAndGuideIconOrder, ns.defaultOrderMap)
leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE = leaderAndGuideIconOrder.Y_OFFSET + 0.1
leaderAndGuideIconOrder.GUIDE = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE + 0.1
BUFPlayerLeaderAndGuideIcon.optionsOrder = leaderAndGuideIconOrder

BUFPlayerLeaderAndGuideIcon.optionsTable = {
	type = "group",
	handler = BUFPlayerLeaderAndGuideIcon,
	name = ns.L["LeaderAndGuideIcon"],
	order = BUFPlayerIndicators.optionsOrder.LEADER_AND_GUIDE_ICON,
	args = {
		separateGuideStyle = {
			type = "toggle",
			name = ns.L["SeparateGuideStyle"],
			desc = ns.L["SeparateGuideStyleDesc"],
			set = function(info, value)
				ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle = value
				BUFPlayerLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle
			end,
			order = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE,
		},
	},
}

---@class BUFDbSchema.UF.Player.LeaderAndGuideIcon
ns.dbDefaults.profile.unitFrames.player.leaderAndGuideIcon = {
	anchorPoint = "TOPLEFT",
	relativeTo = ns.DEFAULT,
	relativePoint = "TOPLEFT",
	xOffset = 86,
	yOffset = -10,
	scale = 1,
	separateGuideStyle = false,
	guide = {
		xOffset = 86,
		yOffset = -10,
		anchorPoint = "TOPLEFT",
		relativeTo = ns.DEFAULT,
		relativePoint = "TOPLEFT",
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
	hidden = function()
		return not ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle
	end,
	inline = true,
	order = leaderAndGuideIconOrder.GUIDE,
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

function BUFPlayerLeaderAndGuideIcon:RefreshConfig()
	if not self.texture then
		self.texture = BUFPlayer.contentContextual.LeaderIcon
		self.defaultRelativeTo = BUFPlayer.contentContextual
	end
	if not Guide.texture then
		Guide.texture = BUFPlayer.contentContextual.GuideIcon
		Guide.defaultRelativeTo = BUFPlayer.contentContextual
	end
	self:RefreshScaleTextureConfig()
	if ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
		self.Guide:RefreshConfig()
	end
end

function BUFPlayerLeaderAndGuideIcon:SetPosition()
	self:_SetPosition(self.texture)

	if not ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
		self.Guide:SetPosition()
	end
end

function BUFPlayerLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
	local isSeparated = ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle
	if isSeparated then
		self.Guide:RefreshConfig()
	else
		self:RefreshConfig()
	end
end

function Guide:RefreshConfig()
	self:RefreshScaleTextureConfig()
end
