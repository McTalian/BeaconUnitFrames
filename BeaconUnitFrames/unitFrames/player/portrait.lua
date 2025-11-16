---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Portrait
ns.dbDefaults.profile.unitFrames.player.portrait = {
    enabled = true,
    xOffset = 24,
    yOffset = -19,
    width = 60,
    height = 60,
    alpha = 1.0,
    mask = true,
}

ns.options.args.unitFrames.args.player.args.portrait = {
    type = "group",
    name = ns.L["Portrait"],
    order = BUFPlayer.optionsOrder.PORTRAIT,
    inline = true,
    args = {
        enabled = {
            type = "toggle",
            name = ENABLE,
            desc = ns.L["EnablePlayerPortrait"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.portrait.enabled = value
                ns.BUFPlayer:ShowHidePortrait()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.portrait.enabled
            end,
            order = 1,
        },
    },
}

function BUFPlayer:ShowHidePortrait()
    local show = ns.db.profile.unitFrames.player.portrait.enabled
    if show then
        self:Unhook(self.container.PlayerPortrait, "Show")
        self:Unhook(self.container.PlayerPortraitMask, "Show")
        self:Unhook(self.container.FrameTexture, "Show")
        self:Unhook(self.container.FrameFlash, "Show")
        self:Unhook(self.contentContextual.PlayerPortraitCornerIcon, "Show")
        self:Unhook(self.contentMain.StatusTexture, "Show")
        self.container.PlayerPortrait:Show()
        self.container.PlayerPortraitMask:Show()
        self.container.FrameTexture:Show()
        PlayerName:SetPoint("TOPLEFT", 88, -27)
        self.restLoop:SetPoint("TOPLEFT", 64, -6)
    else
        self.container.PlayerPortrait:Hide()
        self.container.PlayerPortraitMask:Hide()
        self.container.FrameTexture:Hide()
        self.container.FrameFlash:Hide()
        self.contentContextual.PlayerPortraitCornerIcon:Hide()
        self.contentMain.StatusTexture:Hide()
        self:RawHook(self.container.PlayerPortrait, "Show", ns.noop, true)
        self:RawHook(self.container.PlayerPortraitMask, "Show", ns.noop, true)
        self:RawHook(self.container.FrameTexture, "Show", ns.noop, true)
        self:RawHook(self.container.FrameFlash, "Show", ns.noop, true)
        self:RawHook(self.contentContextual.PlayerPortraitCornerIcon, "Show", ns.noop, true)
        self:RawHook(self.contentMain.StatusTexture, "Show", ns.noop, true)
        PlayerName:SetPoint("TOPLEFT", 3, -27)
        self.restLoop:SetPoint("TOPLEFT", -2, -6)
    end
end
