---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Portrait: BUFConfigHandler, Sizable, Positionable, BoxMaskable
local BUFPlayerPortrait = {
    configPath = "unitFrames.player.portrait",
}

ns.Mixin(BUFPlayerPortrait, ns.Sizable, ns.Positionable, ns.BoxMaskable)

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
    mask = "ui-hud-unitframe-player-portrait-mask",
    maskWidthScale = 1,
    maskHeightScale = 1,
    alpha = 1.0,
}

local portraitOrder = {}
ns.Mixin(portraitOrder, ns.defaultOrderMap)
portraitOrder.CORNER_INDICATOR = portraitOrder.ENABLE + .1

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
            order = portraitOrder.ENABLE,
        },
        -- TODO: Move this to indicators file with more options
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
            order = portraitOrder.CORNER_INDICATOR,
        },
    },
}

ns.AddSizableOptions(portrait.args, portraitOrder)
ns.AddPositionableOptions(portrait.args, portraitOrder)
ns.AddBoxMaskableOptions(portrait.args, portraitOrder)

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
    self:RefreshMask()
end

function BUFPlayerPortrait:SetPosition()
    local parent = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.portrait.xOffset
    local yOffset = ns.db.profile.unitFrames.player.portrait.yOffset
    parent.container.PlayerPortrait:SetPoint("TOPLEFT", xOffset, yOffset)
    parent.container.PlayerPortraitMask:ClearAllPoints()
    parent.container.PlayerPortraitMask:SetPoint("CENTER", parent.container.PlayerPortrait, "CENTER")
end

function BUFPlayerPortrait:ShowHidePortrait()
    local parent = BUFPlayer
    local show = ns.db.profile.unitFrames.player.portrait.enabled
    if show then
        parent:Unhook(parent.container.PlayerPortrait, "Show")
        parent:Unhook(parent.container.PlayerPortraitMask, "Show")
        parent.container.PlayerPortrait:Show()
        parent.container.PlayerPortraitMask:Show()
    else
        parent.container.PlayerPortrait:Hide()
        parent.container.PlayerPortraitMask:Hide()
        if not parent:IsHooked(parent.container.PlayerPortrait, "Show") then
            parent:SecureHook(parent.container.PlayerPortrait, "Show", function(s)
                s:Hide()
            end)
        end
        if not parent:IsHooked(parent.container.PlayerPortraitMask, "Show") then
            parent:SecureHook(parent.container.PlayerPortraitMask, "Show", function(s)
                s:Hide()
            end)
        end
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
            parent:SecureHook(parent.contentContextual.PlayerPortraitCornerIcon, "Show", function(s)
                s:Hide()
            end)
        end
    end
end

function BUFPlayerPortrait:RefreshMask()
    local parent = BUFPlayer
    local maskPath = ns.db.profile.unitFrames.player.portrait.mask

    local sPos, ePos = string.find(maskPath, "%.")
    local isTexture = sPos ~= nil
    if isTexture then
        -- File path
        parent.container.PlayerPortraitMask:SetTexture(maskPath)
    else
        -- Atlas
        parent.container.PlayerPortraitMask:SetAtlas(maskPath, false)
    end
    local width = ns.db.profile.unitFrames.player.portrait.width
    local height = ns.db.profile.unitFrames.player.portrait.height
    local widthScale = ns.db.profile.unitFrames.player.portrait.maskWidthScale or 1
    local heightScale = ns.db.profile.unitFrames.player.portrait.maskHeightScale or 1
    parent.container.PlayerPortraitMask:SetSize(width * widthScale, height * heightScale)
end
