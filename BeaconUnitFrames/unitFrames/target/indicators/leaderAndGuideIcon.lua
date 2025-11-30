---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.LeaderAndGuideIcon: BUFTexture
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
            set = function(info, value)
                ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle = value
                BUFTargetLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle
            end,
            order = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE,
        },
    },
}

ns.BUFTexture:ApplyMixin(BUFTargetLeaderAndGuideIcon)

---@class BUFTarget.LeaderAndGuideIcon.Guide: BUFTexture
local Guide = {
    configPath = "unitFrames.target.leaderAndGuideIcon.guide",
}

Guide.optionsTable = {
    type = "group",
    handler = Guide,
    name = ns.L["GuideIcon"],
    hidden = function()
        return not ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle
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

---@class BUFDbSchema.UF.Target.LeaderAndGuideIcon
ns.dbDefaults.profile.unitFrames.target.leaderAndGuideIcon = {
    anchorPoint = "TOPRIGHT",
    relativeTo = ns.DEFAULT,
    relativePoint = "TOPRIGHT",
    xOffset = -85,
    yOffset = -8,
    useAtlasSize = true,
    width = 16,
    height = 16,
    scale = 1,
    separateGuideStyle = false,
    guide = {
        anchorPoint = "TOPRIGHT",
        relativeTo = ns.DEFAULT,
        relativePoint = "TOPRIGHT",
        xOffset = -85,
        yOffset = -8,
        useAtlasSize = true,
        width = 16,
        height = 16,
        scale = 1,
    }
}

ns.options.args.unitFrames.args.target.args.indicators.args.leaderAndGuideIcon = BUFTargetLeaderAndGuideIcon.optionsTable

local LEADER_ICON_ATLAS = "UI-HUD-UnitFrame-Player-Group-LeaderIcon"
local GUIDE_ICON_ATLAS = "UI-HUD-UnitFrame-Player-Group-GuideIcon"

function BUFTargetLeaderAndGuideIcon:RefreshConfig()
    if not self.texture then
        self.texture = BUFTarget.contentContextual.LeaderIcon
        self.atlasName = LEADER_ICON_ATLAS

        self.defaultRelativeTo = BUFTarget.contentContextual
    end
    if not Guide.texture then
        Guide.texture = BUFTarget.contentContextual.GuideIcon
        Guide.atlasName = GUIDE_ICON_ATLAS

        Guide.defaultRelativeTo = BUFTarget.contentContextual
    end
    self:RefreshTextureConfig()
    if ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle then
        self.Guide:RefreshConfig()
    end
end

function BUFTargetLeaderAndGuideIcon:SetPosition()
    self:_SetPosition(self.texture)

    if not ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle then
        self:_SetPosition(Guide.texture)
    end
end

function BUFTargetLeaderAndGuideIcon:SetSize()
    self:_SetSize(self.texture)

    if not ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle then
        self:_SetSize(Guide.texture, Guide.atlasName)
    end
end

function BUFTargetLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
    local isSeparated = ns.db.profile.unitFrames.target.leaderAndGuideIcon.separateGuideStyle
    if isSeparated then
        self.Guide:RefreshConfig()
    else
        self:RefreshConfig()
    end
end

function Guide:RefreshConfig()
    self:RefreshTextureConfig()
end
