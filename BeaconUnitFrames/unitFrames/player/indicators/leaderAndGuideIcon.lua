---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.LeaderAndGuideIcon: BUFTexture
local BUFPlayerLeaderAndGuideIcon = {
    configPath = "unitFrames.player.leaderAndGuideIcon",
}

local leaderAndGuideIconOrder = {}
ns.Mixin(leaderAndGuideIconOrder, ns.defaultOrderMap)
leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE = leaderAndGuideIconOrder.Y_OFFSET + .1
leaderAndGuideIconOrder.GUIDE = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE + .1
BUFPlayerLeaderAndGuideIcon.orderMap = leaderAndGuideIconOrder

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

ns.BUFTexture:ApplyMixin(BUFPlayerLeaderAndGuideIcon)

---@class BUFPlayer.LeaderAndGuideIcon.Guide: BUFTexture
local Guide = {
    configPath = "unitFrames.player.leaderAndGuideIcon.guide",
}

Guide.optionsTable = {
    type = "group",
    handler = BUFPlayerLeaderAndGuideIcon.Guide,
    name = ns.L["GuideIcon"],
    hidden = function()
        return not ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle
    end,
    inline = true,
    order = leaderAndGuideIconOrder.GUIDE,
    args = {},
}

ns.BUFTexture:ApplyMixin(Guide)

BUFPlayerLeaderAndGuideIcon.Guide = Guide
BUFPlayerLeaderAndGuideIcon.optionsTable.args.guide = Guide.optionsTable
BUFPlayerIndicators.LeaderAndGuideIcon = BUFPlayerLeaderAndGuideIcon

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.LeaderAndGuideIcon
ns.dbDefaults.profile.unitFrames.player.leaderAndGuideIcon = {
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 86,
    yOffset = -10,
    useAtlasSize = true,
    width = 16,
    height = 16,
    scale = 1,
    separateGuideStyle = false,
    guide = {
        xOffset = 86,
        yOffset = -10,
        useAtlasSize = true,
        width = 16,
        height = 16,
        scale = 1,
    }
}

ns.options.args.unitFrames.args.player.args.indicators.args.leaderAndGuideIcon = BUFPlayerLeaderAndGuideIcon.optionsTable

local LEADER_ICON_ATLAS = "UI-HUD-UnitFrame-Player-Group-LeaderIcon"
local GUIDE_ICON_ATLAS = "UI-HUD-UnitFrame-Player-Group-GuideIcon"

function BUFPlayerLeaderAndGuideIcon:RefreshConfig()
    if not self.texture then
        self.texture = BUFPlayer.contentContextual.LeaderIcon
        self.atlasName = LEADER_ICON_ATLAS
    end
    if not Guide.texture then
        Guide.texture = BUFPlayer.contentContextual.GuideIcon
        Guide.atlasName = GUIDE_ICON_ATLAS
    end
    self:RefreshTextureConfig()
    if ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
        self.Guide:RefreshConfig()
    end
end

function BUFPlayerLeaderAndGuideIcon:SetPosition()
    self:_SetPosition(self.texture)

    if not ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
        self:_SetPosition(Guide.texture)
    end
end

function BUFPlayerLeaderAndGuideIcon:SetSize()
    self:_SetSize(self.texture)

    if not ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
        self:_SetSize(Guide.texture, Guide.atlasName)
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
    self:RefreshTextureConfig()
end
