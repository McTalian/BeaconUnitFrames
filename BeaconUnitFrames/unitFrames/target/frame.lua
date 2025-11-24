---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Frame: BUFConfigHandler, Sizable, BackgroundTexturable
local BUFTargetFrame = {
    configPath = "unitFrames.target.frame",
}

ns.ApplyMixin(ns.Sizable, BUFTargetFrame)
ns.ApplyMixin(ns.BackgroundTexturable, BUFTargetFrame)

BUFTarget.Frame = BUFTargetFrame

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Frame
ns.dbDefaults.profile.unitFrames.target.frame = {
    width = 232,
    height = 100,
    enableFrameFlash = true,
    enableFrameTexture = true,
    useBackgroundTexture = false,
    backgroundTexture = "None",
}

local frameOrder = {}

ns.ApplyMixin(ns.defaultOrderMap, frameOrder)
frameOrder.FRAME_FLASH = frameOrder.HEIGHT + .1
frameOrder.FRAME_TEXTURE = frameOrder.FRAME_FLASH + .1
frameOrder.BACKDROP_AND_BORDER = frameOrder.FRAME_TEXTURE + .1

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
ns.AddBackgroundTextureOptions(frame.args, frameOrder)

ns.options.args.unitFrames.args.target.args.frame = frame

function BUFTargetFrame:RefreshConfig()
    self:SetSize()
    self:SetFrameFlash()
    self:SetFrameTexture()
    self:RefreshBackgroundTexture()
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

function BUFTargetFrame:RefreshBackgroundTexture()
    local useBackgroundTexture = ns.db.profile.unitFrames.target.frame.useBackgroundTexture
    if not useBackgroundTexture then
        if self.backdropFrame then
            self.backdropFrame:Hide()
        end
        return
    end

    if not self.backdropFrame then
        self.backdropFrame = CreateFrame("Frame", nil, BUFTarget.frame, "BackdropTemplate")
        self.backdropFrame:SetFrameStrata("BACKGROUND")
    end

    local backgroundTexture = ns.db.profile.unitFrames.target.frame.backgroundTexture
    local bgTexturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, backgroundTexture)
    if not bgTexturePath then
        print("Background texture not found, using default:", "None")
        bgTexturePath = "Interface/None"
    end

    self.backdropFrame:ClearAllPoints()
    self.backdropFrame:SetAllPoints(BUFTarget.frame)

    self.backdropFrame:SetBackdrop({
        bgFile = bgTexturePath,
        edgeFile = nil,
        tile = true,
        tileSize = 16,
        edgeSize = 0,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    self.backdropFrame:Show()
end
