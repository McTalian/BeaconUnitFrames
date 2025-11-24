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
            order = ns.defaultOrderMap.ENABLE,
        },
    },
}

ns.AddSizableOptions(portrait.args)
ns.AddPositionableOptions(portrait.args)

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
        if parent:IsHooked(parent.container.Portrait, "Show") then
            parent:Unhook(parent.container.Portrait, "Show")
        end
        if parent:IsHooked(parent.container.PortraitMask, "Show") then
            parent:Unhook(parent.container.PortraitMask, "Show")
        end
        parent.container.Portrait:Show()
        parent.container.PortraitMask:Show()
    else
        parent.container.Portrait:Hide()
        parent.container.PortraitMask:Hide()
        if not ns.BUFTarget:IsHooked(parent.container.Portrait, "Show") then
            parent:SecureHook(parent.container.Portrait, "Show", function(s)
                s:Hide()
            end)
        end
        if not ns.BUFTarget:IsHooked(parent.container.PortraitMask, "Show") then
            parent:SecureHook(parent.container.PortraitMask, "Show", function(s)
                s:Hide()
            end)
        end
    end
end
