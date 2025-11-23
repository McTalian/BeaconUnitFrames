---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Frame: BUFConfigHandler, Sizable
local BUFTargetFrame = {
    configPath = "unitFrames.target.frame",
}

ns.ApplyMixin(ns.Sizable, BUFTargetFrame)

BUFTarget.Frame = BUFTargetFrame

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Frame
ns.dbDefaults.profile.unitFrames.target.frame = {
    width = 232,
    height = 100,
    enableFrameFlash = true,
    enableFrameTexture = true,
    enableStatusTexture = true,
    enableHitIndicator = true,
}

local frameOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    FRAME_FLASH = 3,
    FRAME_TEXTURE = 4,
    STATUS_TEXTURE = 5,
}

local frame = {
    type = "group",
    handler = BUFTargetFrame,
    name = ns.L["Frame"],
    order = BUFTarget.optionsOrder.FRAME,
    inline = true,
    args = {
        frameFlash = {
            type = "toggle",
            name = ns.L["EnableFrameFlash"],
            set = function(info, value)
                ns.db.profile.unitFrames.target.frame.enableFrameFlash = value
                BUFTargetFrame:SetFrameFlash()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.target.frame.enableFrameFlash
            end,
            order = frameOrder.FRAME_FLASH,
        },
        frameTexture = {
            type = "toggle",
            name = ns.L["EnableFrameTexture"],
            set = function(info, value)
                ns.db.profile.unitFrames.target.frame.enableFrameTexture = value
                BUFTargetFrame:SetFrameTexture()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.target.frame.enableFrameTexture
            end,
            order = frameOrder.FRAME_TEXTURE,
        },
    },
}

ns.AddSizableOptions(frame.args, frameOrder)

ns.options.args.unitFrames.args.target.args.frame = frame

function BUFTargetFrame:RefreshConfig()
    self:SetSize()
    self:SetFrameFlash()
    self:SetFrameTexture()
end

function BUFTargetFrame:SetSize()
    local target = BUFTarget
    local width = ns.db.profile.unitFrames.target.frame.width
    local height = ns.db.profile.unitFrames.target.frame.height
    PixelUtil.SetWidth(target.frame, width, 18)
    PixelUtil.SetHeight(target.frame, height, 18)
end

function BUFTargetFrame:SetFrameFlash()
    local target = BUFTarget
    local enable = ns.db.profile.unitFrames.target.frame.enableFrameFlash
    if enable then
        target:Unhook(target.container.Flash, "Show")
        target.container.Flash:Show()
    else
        target.container.Flash:Hide()
        if not target:IsHooked(target.container.Flash, "Show") then
            target:SecureHook(target.container.Flash, "Show", function(s)
                s:Hide()
            end)
        end
    end
end

function BUFTargetFrame:SetFrameTexture()
    local target = BUFTarget
    local enable = ns.db.profile.unitFrames.target.frame.enableFrameTexture
    if enable then
        target:Unhook(target.container.FrameTexture, "Show")
        target.container.FrameTexture:Show()
    else
        target.container.FrameTexture:Hide()
        if not ns.BUFTarget:IsHooked(target.container.FrameTexture, "Show") then
            target:SecureHook(target.container.FrameTexture, "Show", function(s)
                s:Hide()
            end)
        end
    end
end
