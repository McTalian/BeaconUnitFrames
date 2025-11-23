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

---@class BUFPlayer.Indicators.PrestigePortrait.PrestigeBadge: Positionable, Sizable, Demoable
local PrestigeBadge = {
    configPath = "unitFrames.player.prestigePortrait.prestigeBadge",
}

ns.ApplyMixin(ns.Positionable, PrestigeBadge)
ns.ApplyMixin(ns.Sizable, PrestigeBadge)
ns.ApplyMixin(ns.Demoable, PrestigeBadge)

BUFPlayerPrestigePortrait.PrestigeBadge = PrestigeBadge

BUFPlayerIndicators.PrestigePortrait = BUFPlayerPrestigePortrait

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.PrestigePortrait
ns.dbDefaults.profile.unitFrames.player.prestigePortrait = {
  xOffset = -2,
  yOffset = -38,
  width = 50,
  height = 52,
  prestigeBadge = {
      xOffset = 0,
      yOffset = 0,
      width = 30,
      height = 30,
  },
}

local prestigePortraitOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    WIDTH = 3,
    HEIGHT = 4,
    PRESTIGE_BADGE = 5,
}

local prestigePortrait = {
    type = "group",
    handler = BUFPlayerPrestigePortrait,
    name = ns.L["Prestige Portrait"],
    order = BUFPlayerIndicators.optionsOrder.PRESTIGE_PORTRAIT,
    args = {}
}

ns.AddPositionableOptions(prestigePortrait.args, prestigePortraitOrder)
ns.AddSizableOptions(prestigePortrait.args, prestigePortraitOrder)
ns.AddDemoOptions(prestigePortrait.args, prestigePortraitOrder)

local prestigeBadgeOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    WIDTH = 3,
    HEIGHT = 4,
}

local prestigeBadge = {
    type = "group",
    handler = PrestigeBadge,
    name = ns.L["Prestige Badge"],
    order = prestigePortraitOrder.PRESTIGE_BADGE,
    args = {},
}

ns.AddPositionableOptions(prestigeBadge.args, prestigeBadgeOrder)
ns.AddSizableOptions(prestigeBadge.args, prestigeBadgeOrder)
ns.AddDemoOptions(prestigeBadge.args, prestigeBadgeOrder)

prestigePortrait.args.prestigeBadge = prestigeBadge

ns.options.args.unitFrames.args.player.args.prestigePortrait = prestigePortrait

function BUFPlayerPrestigePortrait:ToggleDemoMode()
    local prestigePortraitFrame = BUFPlayer.contentContextual.PrestigePortrait
    if self.demoMode then
        self.demoMode = false
        prestigePortraitFrame:Hide()
    else
        self.demoMode = true
        prestigePortraitFrame:SetAtlas("honorsystem-portrait-neutral", false)
        prestigePortraitFrame:Show()
        
---@diagnostic disable-next-line: undefined-field
        prestigePortraitFrame.PortraitBackground:Show()
---@diagnostic disable-next-line: undefined-field
        prestigePortraitFrame.SmallWreath:Show()
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

function PrestigeBadge:ToggleDemoMode()
    local prestigeBadgeFrame = BUFPlayer.contentContextual.PrestigeBadge
    if self.demoMode then
        self.demoMode = false
        prestigeBadgeFrame:Hide()
    else
        self.demoMode = true
        prestigeBadgeFrame:SetTexture("interface/pvpframe/icons/prestige-icon-1.blp")
        prestigeBadgeFrame:Show()
    end
end

function PrestigeBadge:RefreshConfig()
    self:SetPosition()
    self:SetSize()
end

function PrestigeBadge:SetPosition()
    local prestigeBadgeFrame = BUFPlayer.contentContextual.PrestigeBadge
    local xOffset = ns.db.profile.unitFrames.player.prestigePortrait.prestigeBadge.xOffset
    local yOffset = ns.db.profile.unitFrames.player.prestigePortrait.prestigeBadge.yOffset

    prestigeBadgeFrame:ClearAllPoints()
    prestigeBadgeFrame:SetPoint("CENTER", BUFPlayer.contentContextual.PrestigePortrait, "CENTER", xOffset, yOffset)
end

function PrestigeBadge:SetSize()
    local prestigeBadgeFrame = BUFPlayer.contentContextual.PrestigeBadge
    local width = ns.db.profile.unitFrames.player.prestigePortrait.prestigeBadge.width
    local height = ns.db.profile.unitFrames.player.prestigePortrait.prestigeBadge.height

    prestigeBadgeFrame:SetSize(width, height)
end
