---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.ReadyCheckIndicator: BUFConfigHandler, Positionable, Sizable, Demoable
local BUFPlayerReadyCheckIndicator = {
    configPath = "unitFrames.player.readyCheckIndicator",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerReadyCheckIndicator)
ns.ApplyMixin(ns.Sizable, BUFPlayerReadyCheckIndicator)
ns.ApplyMixin(ns.Demoable, BUFPlayerReadyCheckIndicator)

BUFPlayerIndicators.ReadyCheckIndicator = BUFPlayerReadyCheckIndicator

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.ReadyCheckIndicator
ns.dbDefaults.profile.unitFrames.player.readyCheckIndicator = {
    xOffset = 0,
    yOffset = 0,
    width = 40,
    height = 40,
}

local readyCheckIndicator = {
    type = "group",
    handler = BUFPlayerReadyCheckIndicator,
    name = ns.L["Ready Check Indicator"],
    order = BUFPlayerIndicators.optionsOrder.READY_CHECK_INDICATOR,
    args = {}
}

ns.AddPositionableOptions(readyCheckIndicator.args)
ns.AddSizableOptions(readyCheckIndicator.args)
ns.AddDemoOptions(readyCheckIndicator.args)

ns.options.args.unitFrames.args.player.args.indicators.args.readyCheckIndicator = readyCheckIndicator

function BUFPlayerReadyCheckIndicator:ToggleDemoMode()
    local readyCheckFrame = BUFPlayer.contentContextual.ReadyCheck
    if self.demoMode then
        self.demoMode = false
        readyCheckFrame:Hide()
    else
        self.demoMode = true
        readyCheckFrame.Texture:SetAtlas(READY_CHECK_READY_TEXTURE)
        readyCheckFrame:Show()
    end
end

function BUFPlayerReadyCheckIndicator:RefreshConfig()
    self:SetPosition()
    self:SetSize()
end

function BUFPlayerReadyCheckIndicator:SetPosition()
    local readyCheckFrame = BUFPlayer.contentContextual.ReadyCheck
    local xOffset = ns.db.profile.unitFrames.player.readyCheckIndicator.xOffset
    local yOffset = ns.db.profile.unitFrames.player.readyCheckIndicator.yOffset
    readyCheckFrame:ClearAllPoints()
    readyCheckFrame:SetPoint("CENTER", BUFPlayer.container.PlayerPortrait, "CENTER", xOffset, yOffset)
end

function BUFPlayerReadyCheckIndicator:SetSize()
    local readyCheckFrame = BUFPlayer.contentContextual.ReadyCheck
    local width = ns.db.profile.unitFrames.player.readyCheckIndicator.width
    local height = ns.db.profile.unitFrames.player.readyCheckIndicator.height
    readyCheckFrame:SetWidth(width)
    readyCheckFrame:SetHeight(height)
end
