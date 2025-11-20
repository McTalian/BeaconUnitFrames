---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Portrait: BUFConfigHandler, Sizable, Positionable
local BUFPlayerPortrait = {
    configPath = "unitFrames.player.portrait",
}

ns.ApplyMixin(ns.Sizable, BUFPlayerPortrait)
ns.ApplyMixin(ns.Positionable, BUFPlayerPortrait)

BUFPlayer.Portrait = BUFPlayerPortrait

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Portrait
ns.dbDefaults.profile.unitFrames.player.portrait = {
    enabled = true,
    width = 60,
    height = 60,
    xOffset = 24,
    yOffset = -19,
    enableCornerIndicator = true,
    mask = "interface/hud/uiunitframeplayerportraitmask.blp",
    alpha = 1.0,
}

local portraitOrder = {
    ENABLED = 1,
    WIDTH = 2,
    HEIGHT = 3,
    X_OFFSET = 4,
    Y_OFFSET = 5,
    CORNER_INDICATOR = 6,
}

local portrait = {
    type = "group",
    handler = BUFPlayerPortrait,
    name = ns.L["Portrait"],
    order = BUFPlayer.optionsOrder.PORTRAIT,
    args = {
        enabled = {
            type = "toggle",
            name = ENABLE,
            desc = ns.L["EnablePlayerPortrait"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.portrait.enabled = value
                BUFPlayerPortrait:ShowHidePortrait()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.portrait.enabled
            end,
            order = 1,
        },
        cornerIndicator = {
            type = "toggle",
            name = ns.L["EnableCornerIndicator"],
            desc = ns.L["EnableCornerIndicatorDesc"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.portrait.enableCornerIndicator = value
                BUFPlayerPortrait:SetCornerIndicator()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.portrait.enableCornerIndicator
            end,
            order = 2,
        },
    },
}

ns.AddSizingOptions(portrait.args, portraitOrder)
ns.AddPositioningOptions(portrait.args, portraitOrder)

ns.options.args.unitFrames.args.player.args.portrait = portrait

function BUFPlayerPortrait:RefreshConfig()
    self:ShowHidePortrait()
    self:SetPosition()
    self:SetSize()
    self:SetCornerIndicator()
end

function BUFPlayerPortrait:SetSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.portrait.width
    local height = ns.db.profile.unitFrames.player.portrait.height
    parent.container.PlayerPortrait:SetWidth(width)
    parent.container.PlayerPortrait:SetHeight(height)
    parent.container.PlayerPortraitMask:SetWidth(width)
    parent.container.PlayerPortraitMask:SetHeight(height)
end

function BUFPlayerPortrait:SetPosition()
    local parent = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.portrait.xOffset
    local yOffset = ns.db.profile.unitFrames.player.portrait.yOffset
    parent.container.PlayerPortrait:SetPoint("TOPLEFT", xOffset, yOffset)
    parent.container.PlayerPortraitMask:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerPortrait:ShowHidePortrait()
    local parent = BUFPlayer
    local show = ns.db.profile.unitFrames.player.portrait.enabled
    if show then
        parent:Unhook(parent.container.PlayerPortrait, "Show")
        parent:Unhook(parent.container.PlayerPortraitMask, "Show")
        parent.container.PlayerPortrait:Show()
        parent.container.PlayerPortraitMask:Show()
        parent.restLoop:SetPoint("TOPLEFT", 64, -6)
    else
        parent.container.PlayerPortrait:Hide()
        parent.container.PlayerPortraitMask:Hide()
        if not parent:IsHooked(parent.container.PlayerPortrait, "Show") then
            parent:RawHook(parent.container.PlayerPortrait, "Show", ns.noop, true)
        end
        if not parent:IsHooked(parent.container.PlayerPortraitMask, "Show") then
            parent:RawHook(parent.container.PlayerPortraitMask, "Show", ns.noop, true)
        end
        parent.restLoop:SetPoint("TOPLEFT", -2, -6)
    end
end

function BUFPlayerPortrait:SetCornerIndicator()
    local parent = BUFPlayer
    local enable = ns.db.profile.unitFrames.player.portrait.enableCornerIndicator
    if enable then
        parent:Unhook(parent.contentContextual.PlayerPortraitCornerIcon, "Show")
        parent.contentContextual.PlayerPortraitCornerIcon:Show()
    else
        parent.contentContextual.PlayerPortraitCornerIcon:Hide()
        if not ns.BUFPlayer:IsHooked(parent.contentContextual.PlayerPortraitCornerIcon, "Show") then
            parent:RawHook(parent.contentContextual.PlayerPortraitCornerIcon, "Show", ns.noop, true)
        end
    end
end
