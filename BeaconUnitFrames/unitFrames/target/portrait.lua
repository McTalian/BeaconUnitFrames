---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Portrait: BUFConfigHandler, Sizable, Positionable
local BUFTargetPortrait = {
    configPath = "unitFrames.target.portrait",
}

ns.ApplyMixin(ns.Sizable, BUFTargetPortrait)
ns.ApplyMixin(ns.Positionable, BUFTargetPortrait)

BUFTarget.Portrait = BUFTargetPortrait

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Portrait
ns.dbDefaults.profile.unitFrames.target.portrait = {
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
    handler = BUFTargetPortrait,
    name = ns.L["Portrait"],
    order = BUFTarget.optionsOrder.PORTRAIT,
    args = {
        enabled = {
            type = "toggle",
            name = ENABLE,
            desc = ns.L["EnablePlayerPortrait"],
            set = function(info, value)
                ns.db.profile.unitFrames.target.portrait.enabled = value
                BUFTargetPortrait:ShowHidePortrait()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.target.portrait.enabled
            end,
            order = 1,
        },
    },
}

ns.AddSizingOptions(portrait.args, portraitOrder)
ns.AddPositioningOptions(portrait.args, portraitOrder)

ns.options.args.unitFrames.args.target.args.portrait = portrait

function BUFTargetPortrait:RefreshConfig()
    self:ShowHidePortrait()
    self:SetPosition()
    self:SetSize()
end

function BUFTargetPortrait:SetSize()
    local parent = BUFTarget
    local width = ns.db.profile.unitFrames.target.portrait.width
    local height = ns.db.profile.unitFrames.target.portrait.height
    parent.container.Portrait:SetWidth(width)
    parent.container.Portrait:SetHeight(height)
    parent.container.PortraitMask:SetWidth(width)
    parent.container.PortraitMask:SetHeight(height)
end

function BUFTargetPortrait:SetPosition()
    local parent = BUFTarget
    local xOffset = ns.db.profile.unitFrames.target.portrait.xOffset
    local yOffset = ns.db.profile.unitFrames.target.portrait.yOffset
    parent.container.Portrait:ClearAllPoints()
    parent.container.PortraitMask:ClearAllPoints()
    parent.container.Portrait:SetPoint("TOPLEFT", xOffset, yOffset)
    parent.container.PortraitMask:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFTargetPortrait:ShowHidePortrait()
    local parent = BUFTarget
    local show = ns.db.profile.unitFrames.target.portrait.enabled
    if show then
        parent:Unhook(parent.container.Portrait, "Show")
        parent:Unhook(parent.container.PortraitMask, "Show")
        parent.container.Portrait:Show()
        parent.container.PortraitMask:Show()
    else
        parent.container.Portrait:Hide()
        parent.container.PortraitMask:Hide()
        parent:RawHook(parent.container.Portrait, "Show", ns.noop, true)
        parent:RawHook(parent.container.PortraitMask, "Show", ns.noop, true)
    end
end
