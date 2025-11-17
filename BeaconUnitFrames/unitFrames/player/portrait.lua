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
    enableCornerIndicator = true,
    mask = "interface/hud/uiunitframeplayerportraitmask.blp",
    xOffset = 24,
    yOffset = -19,
    width = 60,
    height = 60,
    alpha = 1.0,
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
        cornerIndicator = {
            type = "toggle",
            name = ns.L["EnableCornerIndicator"],
            desc = ns.L["EnableCornerIndicatorDesc"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.portrait.enableCornerIndicator = value
                ns.BUFPlayer:SetCornerIndicator()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.portrait.enableCornerIndicator
            end,
            order = 2,
        },
    },
}

function BUFPlayer:RefreshPortraitConfig()
    self:ShowHidePortrait()
    self:SetCornerIndicator()
end

function BUFPlayer:ShowHidePortrait()
    local show = ns.db.profile.unitFrames.player.portrait.enabled
    if show then
        self:Unhook(self.container.PlayerPortrait, "Show")
        self:Unhook(self.container.PlayerPortraitMask, "Show")
        self.container.PlayerPortrait:Show()
        self.container.PlayerPortraitMask:Show()
        self.restLoop:SetPoint("TOPLEFT", 64, -6)
    else
        self.container.PlayerPortrait:Hide()
        self.container.PlayerPortraitMask:Hide()
        self:RawHook(self.container.PlayerPortrait, "Show", ns.noop, true)
        self:RawHook(self.container.PlayerPortraitMask, "Show", ns.noop, true)
        self.restLoop:SetPoint("TOPLEFT", -2, -6)
    end
end

function BUFPlayer:SetCornerIndicator()
    local enable = ns.db.profile.unitFrames.player.portrait.enableCornerIndicator
    if enable then
        self:Unhook(self.contentContextual.PlayerPortraitCornerIcon, "Show")
        self.contentContextual.PlayerPortraitCornerIcon:Show()
    else
        self.contentContextual.PlayerPortraitCornerIcon:Hide()
        self:RawHook(self.contentContextual.PlayerPortraitCornerIcon, "Show", ns.noop, true)
    end
end
