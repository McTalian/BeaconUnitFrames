---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Frame: BUFConfigHandler, Sizable, BackgroundTexturable
local BUFPlayerFrame = {
    configPath = "unitFrames.player.frame",
}

ns.ApplyMixin(ns.Sizable, BUFPlayerFrame)
ns.ApplyMixin(ns.BackgroundTexturable, BUFPlayerFrame)

BUFPlayer.Frame = BUFPlayerFrame

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Frame
ns.dbDefaults.profile.unitFrames.player.frame = {
    width = 232,
    height = 100,
    enableFrameFlash = true,
    enableFrameTexture = true,
    enableStatusTexture = true,
    enableHitIndicator = true,
    useBackgroundTexture = false,
    backgroundTexture = "None",
}

local frameOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    FRAME_FLASH = 3,
    FRAME_TEXTURE = 4,
    STATUS_TEXTURE = 5,
    HIT_INDICATOR = 6,
    BACKDROP_AND_BORDER = 7,
}

local backdropAndBorderOrder = {
    USE_BACKGROUND_TEXTURE = 1,
    BACKGROUND_TEXTURE = 2,
}

local frame = {
    type = "group",
    handler = BUFPlayerFrame,
    name = ns.L["Frame"],
    order = BUFPlayer.optionsOrder.FRAME,
    inline = true,
    args = {
        frameFlash = {
            type = "toggle",
            name = ns.L["EnableFrameFlash"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.enableFrameFlash = value
                BUFPlayerFrame:SetFrameFlash()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.enableFrameFlash
            end,
            order = frameOrder.FRAME_FLASH,
        },
        frameTexture = {
            type = "toggle",
            name = ns.L["EnableFrameTexture"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.enableFrameTexture = value
                BUFPlayerFrame:SetFrameTexture()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.enableFrameTexture
            end,
            order = frameOrder.FRAME_TEXTURE,
        },
        statusTexture = {
            type = "toggle",
            name = ns.L["EnableStatusTexture"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.enableStatusTexture = value
                BUFPlayerFrame:SetStatusTexture()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.enableStatusTexture
            end,
            order = frameOrder.STATUS_TEXTURE,
        },
        hitIndicator = {
            type = "toggle",
            name = ns.L["EnableHitIndicator"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.enableHitIndicator = value
                BUFPlayerFrame:SetHitIndicator()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.enableHitIndicator
            end,
            order = frameOrder.HIT_INDICATOR,
        },
        backdropAndBorder = {
            type = "group",
            name = ns.L["BackdropAndBorder"],
            order = frameOrder.BACKDROP_AND_BORDER,
            args = {}
        }
    },
}

ns.AddBackgroundTextureOptions(frame.args.backdropAndBorder.args, backdropAndBorderOrder)

ns.AddSizingOptions(frame.args, frameOrder)

ns.options.args.unitFrames.args.player.args.frame = frame

function BUFPlayerFrame:RefreshConfig()
    self:SetSize()
    self:SetFrameFlash()
    self:SetFrameTexture()
    self:SetStatusTexture()
    self:SetHitIndicator()
    self:RefreshBackgroundTexture()
end

function BUFPlayerFrame:SetSize()
    local player = BUFPlayer
    local width = ns.db.profile.unitFrames.player.frame.width
    local height = ns.db.profile.unitFrames.player.frame.height
    PixelUtil.SetWidth(player.frame, width, 18)
    PixelUtil.SetHeight(player.frame, height, 18)
end

function BUFPlayerFrame:SetFrameFlash()
    local player = BUFPlayer
    local enable = ns.db.profile.unitFrames.player.frame.enableFrameFlash
    if enable then
        player:Unhook(player.container.FrameFlash, "Show")
        player.container.FrameFlash:Show()
    else
        player.container.FrameFlash:Hide()
        if not ns.BUFPlayer:IsHooked(player.container.FrameFlash, "Show") then
            player:RawHook(player.container.FrameFlash, "Show", ns.noop, true)
        end
    end
end

function BUFPlayerFrame:SetFrameTexture()
    local player = BUFPlayer
    local enable = ns.db.profile.unitFrames.player.frame.enableFrameTexture
    if enable then
        player:Unhook(player.container.FrameTexture, "Show")
        player.container.FrameTexture:Show()
    else
        player.container.FrameTexture:Hide()
        if not ns.BUFPlayer:IsHooked(player.container.FrameTexture, "Show") then
            player:RawHook(player.container.FrameTexture, "Show", ns.noop, true)
        end
    end
end

function BUFPlayerFrame:SetStatusTexture()
    local player = BUFPlayer
    local enable = ns.db.profile.unitFrames.player.frame.enableStatusTexture
    if enable then
        player:Unhook(player.contentMain.StatusTexture, "Show")
        player.contentMain.StatusTexture:Show()
    else
        player.contentMain.StatusTexture:Hide()
        if not ns.BUFPlayer:IsHooked(player.contentMain.StatusTexture, "Show") then
            player:RawHook(player.contentMain.StatusTexture, "Show", ns.noop, true)
        end
    end
end

function BUFPlayerFrame:SetHitIndicator()
    local player = BUFPlayer
    local enable = ns.db.profile.unitFrames.player.frame.enableHitIndicator
    if enable then
        player:Unhook(player.contentMain.HitIndicator, "Show")
        player.contentMain.HitIndicator:Show()
    else
        player.contentMain.HitIndicator:Hide()
        if not ns.BUFPlayer:IsHooked(player.contentMain.HitIndicator, "Show") then
            player:RawHook(player.contentMain.HitIndicator, "Show", ns.noop, true)
        end
    end
end

function BUFPlayerFrame:RefreshBackgroundTexture()
    local useBackgroundTexture = ns.db.profile.unitFrames.player.frame.useBackgroundTexture
    if not useBackgroundTexture then
        if self.backdropFrame then
            self.backdropFrame:Hide()
        end
        return
    end

    if self.backdropFrame == nil then
        self.backdropFrame = CreateFrame("Frame", nil, ns.BUFPlayer.frame, "BackdropTemplate")
    end

    local backgroundTexture = ns.db.profile.unitFrames.player.frame.backgroundTexture
    local bgTexturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, backgroundTexture)
    if not bgTexturePath then
        print("Background texture not found, using default:", "None")
        bgTexturePath = "Interface/None"
    end

    self.backdropFrame:ClearAllPoints()
    self.backdropFrame:SetAllPoints(ns.BUFPlayer.frame)

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
