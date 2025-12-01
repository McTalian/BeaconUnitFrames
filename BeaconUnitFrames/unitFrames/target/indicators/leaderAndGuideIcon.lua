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
leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE = leaderAndGuideIconOrder.Y_OFFSET + .1
leaderAndGuideIconOrder.GUIDE = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE + .1
BUFTargetLeaderAndGuideIcon.orderMap = leaderAndGuideIconOrder

BUFTargetLeaderAndGuideIcon.optionsTable = {
    type = "group",
    handler = BUFTargetLeaderAndGuideIcon,
    name = ns.L["LeaderAndGuideIcon"],
    order = BUFTargetIndicators.optionsOrder.LEADER_AND_GUIDE_ICON,
    args = {
        separateGuideStyle = {
            type = "toggle",
            name = ns.L["SeparateGuideStyle"],
            desc = ns.L["SeparateGuideStyleDesc"],
            set = "SetUseSeparateGuideStyle",
            get = "GetUseSeparateGuideStyle",
            order = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE,
        },
    },
}

---@class BUFDbSchema.UF.Target.LeaderAndGuideIcon
BUFTargetLeaderAndGuideIcon.dbDefaults = {
    anchorPoint = "TOPRIGHT",
    relativeTo = ns.DEFAULT,
    relativePoint = "TOPRIGHT",
    xOffset = -85,
    yOffset = -8,
    scale = 1,
    separateGuideStyle = false,
    guide = {
        anchorPoint = "TOPRIGHT",
        relativeTo = ns.DEFAULT,
        relativePoint = "TOPRIGHT",
        xOffset = -85,
        yOffset = -8,
        scale = 1,
    }
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
    hidden = function()
        return not BUFTargetLeaderAndGuideIcon:GetUseSeparateGuideStyle()
    end,
    inline = true,
    order = leaderAndGuideIconOrder.GUIDE,
    args = {},
}

ns.BUFTexture:ApplyMixin(Guide)

BUFTargetLeaderAndGuideIcon.Guide = Guide
BUFTargetLeaderAndGuideIcon.optionsTable.args.guide = Guide.optionsTable
BUFTargetIndicators.LeaderAndGuideIcon = BUFTargetLeaderAndGuideIcon

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.leaderAndGuideIcon = BUFTargetLeaderAndGuideIcon.dbDefaults

ns.options.args.target.args.indicators.args.leaderAndGuideIcon = BUFTargetLeaderAndGuideIcon.optionsTable

function BUFTargetLeaderAndGuideIcon:SetUseSeparateGuideStyle(info, value)
    ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle = value
    BUFTargetLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
end

function BUFTargetLeaderAndGuideIcon:GetUseSeparateGuideStyle(info)
    return ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle
end

function BUFTargetLeaderAndGuideIcon:RefreshConfig()
    if not self.texture then
        self.texture = BUFTarget.contentContextual.LeaderIcon
        self.defaultRelativeTo = BUFTarget.contentContextual
    end
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

function Guide:RefreshConfig()
    if not self.texture then
        self.texture = BUFTarget.contentContextual.GuideIcon
        self.defaultRelativeTo = BUFTarget.contentContextual
    end
    if BUFTargetLeaderAndGuideIcon:GetUseSeparateGuideStyle() then
        self:RefreshScaleTextureConfig()
    end
end
