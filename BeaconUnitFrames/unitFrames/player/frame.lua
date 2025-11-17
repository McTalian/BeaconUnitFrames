---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Frame
ns.dbDefaults.profile.unitFrames.player.frame = {
    width = 232,
    height = 100,
    enableFrameFlash = true,
    enableFrameTexture = true,
    enableStatusTexture = true,
}

ns.options.args.unitFrames.args.player.args.frame = {
    type = "group",
    name = ns.L["Frame"],
    order = BUFPlayer.optionsOrder.FRAME,
    inline = true,
    args = {
        width = {
            type = "range",
            name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_WIDTH,
            min = 1,
            softMin = 50,
            softMax = 800,
            max = 1000000000,
            step = 1,
            bigStep = 10,
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.width = value
                ns.BUFPlayer:SetFrameSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.width
            end,
            order = 1,
        },
        height = {
            type = "range",
            name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_HEIGHT,
            min = 1,
            softMin = 50,
            softMax = 600,
            max = 1000000000,
            step = 1,
            bigStep = 10,
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.height = value
                ns.BUFPlayer:SetFrameSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.height
            end,
            order = 2,
        },
        frameFlash = {
            type = "toggle",
            name = ns.L["EnableFrameFlash"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.enableFrameFlash = value
                ns.BUFPlayer:SetFrameFlash()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.enableFrameFlash
            end,
            order = 3,
        },
        frameTexture = {
            type = "toggle",
            name = ns.L["EnableFrameTexture"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.enableFrameTexture = value
                ns.BUFPlayer:SetFrameTexture()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.enableFrameTexture
            end,
            order = 4,
        },
        statusTexture = {
            type = "toggle",
            name = ns.L["EnableStatusTexture"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.frame.enableStatusTexture = value
                ns.BUFPlayer:SetStatusTexture()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.frame.enableStatusTexture
            end,
            order = 5,
        },
    },
}

function BUFPlayer:RefreshFrameConfig()
    self:SetFrameSize()
end

function BUFPlayer:SetFrameSize()
    local width = ns.db.profile.unitFrames.player.frame.width
    local height = ns.db.profile.unitFrames.player.frame.height
    PixelUtil.SetWidth(self.frame, width, 18)
    PixelUtil.SetHeight(self.frame, height, 18)
end

function BUFPlayer:SetFrameFlash()
    local enable = ns.db.profile.unitFrames.player.frame.enableFrameFlash
    if enable then
        self:Unhook(self.container.FrameFlash, "Show")
        self.container.FrameFlash:Show()
    else
        self.container.FrameFlash:Hide()
        self:RawHook(self.container.FrameFlash, "Show", ns.noop, true)
    end
end

function BUFPlayer:SetFrameTexture()
    local enable = ns.db.profile.unitFrames.player.frame.enableFrameTexture
    if enable then
        self:Unhook(self.container.FrameTexture, "Show")
        self.container.FrameTexture:Show()
    else
        self.container.FrameTexture:Hide()
        self:RawHook(self.container.FrameTexture, "Show", ns.noop, true)
    end
end

function BUFPlayer:SetStatusTexture()
    local enable = ns.db.profile.unitFrames.player.frame.enableStatusTexture
    if enable then
        self:Unhook(self.contentMain.StatusTexture, "Show")
        self.contentMain.StatusTexture:Show()
    else
        self.contentMain.StatusTexture:Hide()
        self:RawHook(self.contentMain.StatusTexture, "Show", ns.noop, true)
    end
end
