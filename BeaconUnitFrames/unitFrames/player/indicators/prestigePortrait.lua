---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.PrestigePortrait: BUFConfigHandler, Positionable, Sizable, Demoable
local BUFPlayerPrestigePortrait = {
    configPath = "unitFrames.player.prestigePortrait",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerPrestigePortrait)
ns.ApplyMixin(ns.Sizable, BUFPlayerPrestigePortrait)
ns.ApplyMixin(ns.Demoable, BUFPlayerPrestigePortrait)

BUFPlayerIndicators.PrestigePortrait = BUFPlayerPrestigePortrait

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.PrestigePortrait
ns.dbDefaults.profile.unitFrames.player.prestigePortrait = {
  xOffset = -2,
  yOffset = -38,
  width = 50,
  height = 52,
}

local prestigePortrait = {
    type = "group",
    handler = BUFPlayerPrestigePortrait,
    name = ns.L["Prestige Portrait"],
    order = BUFPlayerIndicators.optionsOrder.PRESTIGE_PORTRAIT,
    args = {}
}

ns.AddPositionableOptions(prestigePortrait.args)
ns.AddSizableOptions(prestigePortrait.args)
ns.AddDemoOptions(prestigePortrait.args)

ns.options.args.unitFrames.args.player.args.indicators.args.prestigePortrait = prestigePortrait

function BUFPlayerPrestigePortrait:ToggleDemoMode()
    local prestigePortraitFrame = BUFPlayer.contentContextual.PrestigePortrait
    local prestigeBadgeFrame = BUFPlayer.contentContextual.PrestigeBadge
    if self.demoMode then
        self.demoMode = false
        prestigePortraitFrame:Hide()
        prestigeBadgeFrame:Hide()
    else
        self.demoMode = true
        prestigePortraitFrame:SetAtlas("honorsystem-portrait-neutral", false)
        prestigePortraitFrame:Show()
        prestigeBadgeFrame:SetTexture("interface/pvpframe/icons/prestige-icon-1.blp")
        prestigeBadgeFrame:Show()
    end
end

function BUFPlayerPrestigePortrait:RefreshConfig()
    self:SetPosition()
    self:SetSize()
end

function BUFPlayerPrestigePortrait:SetPosition()
    local prestigePortraitFrame = BUFPlayer.contentContextual.PrestigePortrait
    local xOffset = ns.db.profile.unitFrames.player.prestigePortrait.xOffset
    local yOffset = ns.db.profile.unitFrames.player.prestigePortrait.yOffset

    prestigePortraitFrame:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerPrestigePortrait:SetSize()
    local prestigePortraitFrame = BUFPlayer.contentContextual.PrestigePortrait
    local width = ns.db.profile.unitFrames.player.prestigePortrait.width
    local height = ns.db.profile.unitFrames.player.prestigePortrait.height

    prestigePortraitFrame:SetSize(width, height)
end
