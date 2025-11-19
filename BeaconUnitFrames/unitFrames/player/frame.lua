---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Frame: BUFConfigHandler, Sizable
local BUFPlayerFrame = {
    configPath = "unitFrames.player.frame",
}

ns.ApplyMixin(ns.Sizable, BUFPlayerFrame)

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
}

local frameOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    FRAME_FLASH = 3,
    FRAME_TEXTURE = 4,
    STATUS_TEXTURE = 5,
    HIT_INDICATOR = 6,
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
    },
}

ns.AddSizingOptions(frame.args, frameOrder)

ns.options.args.unitFrames.args.player.args.frame = frame

function BUFPlayerFrame:RefreshConfig()
    self:SetSize()
    self:SetFrameFlash()
    self:SetFrameTexture()
    self:SetStatusTexture()
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
        player:RawHook(player.container.FrameFlash, "Show", ns.noop, true)
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
        player:RawHook(player.container.FrameTexture, "Show", ns.noop, true)
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
        player:RawHook(player.contentMain.StatusTexture, "Show", ns.noop, true)
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
        player:RawHook(player.contentMain.HitIndicator, "Show", ns.noop, true)
    end
end
