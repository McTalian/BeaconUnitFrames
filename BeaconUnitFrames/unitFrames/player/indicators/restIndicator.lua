---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.RestIndicator: BUFConfigHandler, Positionable, Sizable, Demoable
local BUFPlayerRestIndicator = {
    configPath = "unitFrames.player.restIndicator",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerRestIndicator)
ns.ApplyMixin(ns.Sizable, BUFPlayerRestIndicator)
ns.ApplyMixin(ns.Demoable, BUFPlayerRestIndicator)

BUFPlayerIndicators.RestIndicator = BUFPlayerRestIndicator

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.RestIndicator
ns.dbDefaults.profile.unitFrames.player.restIndicator = {
    xOffset = 64,
    yOffset = -6,
    width = 30,
    height = 30,
}

local restIndicator = {
    type = "group",
    handler = BUFPlayerRestIndicator,
    name = ns.L["Rest Indicator"],
    order = BUFPlayerIndicators.optionsOrder.REST_INDICATOR,
    args = {}
}

ns.AddPositionableOptions(restIndicator.args)
ns.AddSizableOptions(restIndicator.args)
ns.AddDemoOptions(restIndicator.args)

ns.options.args.unitFrames.args.player.args.indicators.args.restIndicator = restIndicator

function BUFPlayerRestIndicator:ToggleDemoMode()
    local restIndicatorFrame = BUFPlayer.contentContextual.PlayerRestLoop
    if self.demoMode then
        self.demoMode = false
        restIndicatorFrame:Hide()
        restIndicatorFrame.PlayerRestLoopAnim:Stop()
    else
        self.demoMode = true
        restIndicatorFrame:Show()
        restIndicatorFrame.PlayerRestLoopAnim:Play()
    end
end

function BUFPlayerRestIndicator:RefreshConfig()
    self:SetPosition()
    self:SetSize()
end

function BUFPlayerRestIndicator:SetPosition()
    local restIndicatorFrame = BUFPlayer.contentContextual.PlayerRestLoop
    local xOffset = ns.db.profile.unitFrames.player.restIndicator.xOffset
    local yOffset = ns.db.profile.unitFrames.player.restIndicator.yOffset

    restIndicatorFrame:ClearAllPoints()
    restIndicatorFrame:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerRestIndicator:SetSize()
    local restTexture = BUFPlayer.contentContextual.PlayerRestLoop.RestTexture
    local width = ns.db.profile.unitFrames.player.restIndicator.width
    local height = ns.db.profile.unitFrames.player.restIndicator.height

    restTexture:SetSize(width, height)
end
