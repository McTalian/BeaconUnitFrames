---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.PlayTime: BUFConfigHandler, Positionable, Sizable, Demoable
local BUFPlayerPlayTime = {
    configPath = "unitFrames.player.playTime",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerPlayTime)
ns.ApplyMixin(ns.Sizable, BUFPlayerPlayTime)
ns.ApplyMixin(ns.Demoable, BUFPlayerPlayTime)

BUFPlayer.PlayTime = BUFPlayerPlayTime

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.PlayTime
ns.dbDefaults.profile.unitFrames.player.playTime = {
    xOffset = -21,
    yOffset = -24,
    width = 29,
    height = 29,
}

local playTimeOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    WIDTH = 3,
    HEIGHT = 4,
}

local playTime = {
    type = "group",
    handler = BUFPlayerPlayTime,
    name = ns.L["Play Time"],
    order = BUFPlayer.optionsOrder.PLAY_TIME,
    args = {}
}

ns.AddPositioningOptions(playTime.args, playTimeOrder)
ns.AddSizingOptions(playTime.args, playTimeOrder)
ns.AddDemoOptions(playTime.args, playTimeOrder)

ns.options.args.unitFrames.args.player.args.playTime = playTime

function BUFPlayerPlayTime:ToggleDemoMode()
    local playTimeFrame = BUFPlayer.contentContextual.PlayerPlayTime
    if self.demoMode then
        self.demoMode = false
        playTimeFrame:Hide()
    else
        self.demoMode = true
        playTimeFrame:Show()
    end
end

function BUFPlayerPlayTime:RefreshConfig()
    self:SetPosition()
    self:SetSize()
end

function BUFPlayerPlayTime:SetPosition()
    local playTimeFrame = BUFPlayer.contentContextual.PlayerPlayTime
    local xOffset = ns.db.profile.unitFrames.player.playTime.xOffset
    local yOffset = ns.db.profile.unitFrames.player.playTime.yOffset

    playTimeFrame:ClearAllPoints()
    playTimeFrame:SetPoint("TOPLEFT", BUFPlayer.contentContextual, "TOPRIGHT", xOffset, yOffset)
end

function BUFPlayerPlayTime:SetSize()
    local playTimeFrame = BUFPlayer.contentContextual.PlayerPlayTime
    local width = ns.db.profile.unitFrames.player.playTime.width
    local height = ns.db.profile.unitFrames.player.playTime.height

    playTimeFrame:SetSize(width, height)
end

