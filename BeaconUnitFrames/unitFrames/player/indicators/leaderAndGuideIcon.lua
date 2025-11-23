---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.LeaderAndGuideIcon: BUFConfigHandler, Positionable, AtlasSizable, Demoable
local BUFPlayerLeaderAndGuideIcon = {
    configPath = "unitFrames.player.leaderAndGuideIcon",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerLeaderAndGuideIcon)
ns.ApplyMixin(ns.AtlasSizable, BUFPlayerLeaderAndGuideIcon)
ns.ApplyMixin(ns.Demoable, BUFPlayerLeaderAndGuideIcon)

---@class BUFPlayer.LeaderAndGuideIcon.Guide: Positionable, AtlasSizable, Demoable
local Guide = {
    configPath = "unitFrames.player.leaderAndGuideIcon.guide",
}

ns.ApplyMixin(ns.Positionable, Guide)
ns.ApplyMixin(ns.AtlasSizable, Guide)
ns.ApplyMixin(ns.Demoable, Guide)

BUFPlayerLeaderAndGuideIcon.Guide = Guide

BUFPlayerIndicators.LeaderAndGuideIcon = BUFPlayerLeaderAndGuideIcon

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.LeaderAndGuideIcon
ns.dbDefaults.profile.unitFrames.player.leaderAndGuideIcon = {
    xOffset = 86,
    yOffset = -10,
    useAtlasSize = true,
    width = 16,
    height = 16,
    separateGuideStyle = false,
    guide = {
        xOffset = 86,
        yOffset = -10,
        useAtlasSize = true,
        width = 16,
        height = 16,
    }
}

local leaderAndGuideIconOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    USE_ATLAS_SIZE = 3,
    WIDTH = 4,
    HEIGHT = 5,
    SEPARATE_GUIDE_STYLE = 6,
    GUIDE = 7,
}

local guideOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    USE_ATLAS_SIZE = 3,
    WIDTH = 4,
    HEIGHT = 5,
}

local leaderAndGuideIcon = {
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
                -- TODO: Call some refresh function
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle
            end,
            order = leaderAndGuideIconOrder.SEPARATE_GUIDE_STYLE,
        },
    },
}

ns.AddPositionableOptions(leaderAndGuideIcon.args, leaderAndGuideIconOrder)
ns.AddAtlasSizableOptions(leaderAndGuideIcon.args, leaderAndGuideIconOrder)
ns.AddDemoOptions(leaderAndGuideIcon.args, leaderAndGuideIconOrder)

local guideGroup = {
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

ns.AddPositionableOptions(guideGroup.args, guideOrder)
ns.AddAtlasSizableOptions(guideGroup.args, guideOrder)
ns.AddDemoOptions(guideGroup.args, guideOrder)

leaderAndGuideIcon.args.guide = guideGroup

ns.options.args.unitFrames.args.player.args.leaderAndGuideIcon = leaderAndGuideIcon

local LEADER_ICON_ATLAS = "UI-HUD-UnitFrame-Player-Group-LeaderIcon"
local GUIDE_ICON_ATLAS = "UI-HUD-UnitFrame-Player-Group-GuideIcon"

function BUFPlayerLeaderAndGuideIcon:ToggleDemoMode()
    local leaderIcon = BUFPlayer.contentContextual.LeaderIcon

    if self.demoMode then
        self.demoMode = false
        leaderIcon:Hide()
    else
        self.demoMode = true
        leaderIcon:Show()
    end
end

function Guide:ToggleDemoMode()
    local guideIcon = BUFPlayer.contentContextual.GuideIcon

    if self.demoMode then
        self.demoMode = false
        guideIcon:Hide()
    else
        self.demoMode = true
        guideIcon:Show()
    end
end

function BUFPlayerLeaderAndGuideIcon:RefreshConfig()
    self:SetPosition()
    self:SetSize()
    if ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
        self.Guide:RefreshConfig()
    end
end

function BUFPlayerLeaderAndGuideIcon:SetPosition()
    local leaderIcon = BUFPlayer.contentContextual.LeaderIcon
    local guideIcon = BUFPlayer.contentContextual.GuideIcon
    local xOffset = ns.db.profile.unitFrames.player.leaderAndGuideIcon.xOffset
    local yOffset = ns.db.profile.unitFrames.player.leaderAndGuideIcon.yOffset
    leaderIcon:SetPoint("TOPLEFT", xOffset, yOffset)
    if not ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
        guideIcon:SetPoint("TOPLEFT", xOffset, yOffset)
    end
end

function BUFPlayerLeaderAndGuideIcon:SetSize()
    local leaderIcon = BUFPlayer.contentContextual.LeaderIcon
    local guideIcon = BUFPlayer.contentContextual.GuideIcon
    if ns.db.profile.unitFrames.player.leaderAndGuideIcon.useAtlasSize then
        leaderIcon:SetAtlas(LEADER_ICON_ATLAS, true)
        if not ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
            guideIcon:SetAtlas(GUIDE_ICON_ATLAS, true)
        end
        return
    end

    local width = ns.db.profile.unitFrames.player.leaderAndGuideIcon.width
    local height = ns.db.profile.unitFrames.player.leaderAndGuideIcon.height
    leaderIcon:SetAtlas(LEADER_ICON_ATLAS, false)
    PixelUtil.SetSize(leaderIcon, width, height, 4, 4)
    if not ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle then
        guideIcon:SetAtlas(GUIDE_ICON_ATLAS, false)
        PixelUtil.SetSize(guideIcon, width, height, 4, 4)
    end
end

function BUFPlayerLeaderAndGuideIcon:SeparateLeaderAndGuideStyle()
    local guideIcon = BUFPlayer.contentContextual.GuideIcon
    local isSeparated = ns.db.profile.unitFrames.player.leaderAndGuideIcon.separateGuideStyle
    if isSeparated then
        self.Guide:RefreshConfig()
    else
        self:RefreshConfig()
    end
end

function Guide:RefreshConfig()
    self:SetPosition()
    self:SetSize()
end

function Guide:SetPosition()
    local guideIcon = BUFPlayer.contentContextual.GuideIcon
    local xOffset = ns.db.profile.unitFrames.player.leaderAndGuideIcon.guide.xOffset
    local yOffset = ns.db.profile.unitFrames.player.leaderAndGuideIcon.guide.yOffset
    guideIcon:SetPoint("TOPLEFT", xOffset, yOffset)
end

function Guide:SetSize()
    local guideIcon = BUFPlayer.contentContextual.GuideIcon
    if ns.db.profile.unitFrames.player.leaderAndGuideIcon.guide.useAtlasSize then
        guideIcon:SetAtlas(GUIDE_ICON_ATLAS, true)
        return
    end

    local width = ns.db.profile.unitFrames.player.leaderAndGuideIcon.guide.width
    local height = ns.db.profile.unitFrames.player.leaderAndGuideIcon.guide.height
    guideIcon:SetAtlas(GUIDE_ICON_ATLAS, false)
    PixelUtil.SetSize(guideIcon, width, height, 4, 4)
end
