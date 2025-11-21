---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.RestIndicator: BUFConfigHandler, Positionable, Sizable, Demoable
local BUFPlayerRestIndicator = {
    configPath = "unitFrames.player.restIndicator",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerRestIndicator)
ns.ApplyMixin(ns.Sizable, BUFPlayerRestIndicator)
ns.ApplyMixin(ns.Demoable, BUFPlayerRestIndicator)

BUFPlayer.RestIndicator = BUFPlayerRestIndicator

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.RestIndicator
ns.dbDefaults.profile.unitFrames.player.restIndicator = {
    xOffset = 64,
    yOffset = -6,
    width = 30,
    height = 30,
}

local restIndicatorOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    WIDTH = 3,
    HEIGHT = 4,
}

local restIndicator = {
    type = "group",
    handler = BUFPlayerRestIndicator,
    name = ns.L["Rest Indicator"],
    order = BUFPlayer.optionsOrder.REST_INDICATOR,
    args = {}
}

ns.AddPositioningOptions(restIndicator.args, restIndicatorOrder)
ns.AddSizingOptions(restIndicator.args, restIndicatorOrder)
ns.AddDemoOptions(restIndicator.args, restIndicatorOrder)

ns.options.args.unitFrames.args.player.args.restIndicator = restIndicator

function BUFPlayerRestIndicator:ToggleDemoMode()
    local restIndicatorFrame = BUFPlayer.contentContextual.PlayerRestLoop
    if self.demoMode then
        self.demoMode = false
        restIndicatorFrame:Hide()
    else
        self.demoMode = true
        restIndicatorFrame:Show()
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
