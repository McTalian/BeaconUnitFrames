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
    },
}

function BUFPlayer:SetFrameSize()
    local width = ns.db.profile.unitFrames.player.frame.width
    local height = ns.db.profile.unitFrames.player.frame.height
    PixelUtil.SetWidth(self.frame, width, 18)
    PixelUtil.SetHeight(self.frame, height, 18)
end
