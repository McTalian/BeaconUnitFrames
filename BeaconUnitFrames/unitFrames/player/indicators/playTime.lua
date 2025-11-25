---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.PlayTime: BUFConfigHandler, Positionable, Sizable, Demoable
local BUFPlayerPlayTime = {
    configPath = "unitFrames.player.playTime",
}

ns.Mixin(BUFPlayerPlayTime, ns.Positionable, ns.Sizable, ns.Demoable)

BUFPlayerIndicators.PlayTime = BUFPlayerPlayTime

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.PlayTime
ns.dbDefaults.profile.unitFrames.player.playTime = {
    xOffset = -21,
    yOffset = -24,
    width = 29,
    height = 29,
}

local playTime = {
    type = "group",
    handler = BUFPlayerPlayTime,
    name = ns.L["Play Time"],
    order = BUFPlayerIndicators.optionsOrder.PLAY_TIME,
    args = {}
}

ns.AddPositionableOptions(playTime.args)
ns.AddSizableOptions(playTime.args)
ns.AddDemoOptions(playTime.args)

ns.options.args.unitFrames.args.player.args.indicators.args.playTime = playTime

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

