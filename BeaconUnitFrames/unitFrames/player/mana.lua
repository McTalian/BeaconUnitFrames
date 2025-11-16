---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Mana
ns.dbDefaults.profile.unitFrames.player.manaBar = {
    width = 124,
    height = 10,
    xOffset = 85,
    yOffset = -61,
}

ns.options.args.unitFrames.args.player.args.manaBar = {
    type = "group",
    name = MANA,
    order = BUFPlayer.optionsOrder.MANA,
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
                ns.db.profile.unitFrames.player.manaBar.width = value
                ns.BUFPlayer:SetManaSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.manaBar.width
            end,
            order = 1,
        },
        height = {
            type = "range",
            name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_HEIGHT,
            min = 1,
            softMin = 5,
            softMax = 200,
            max = 1000000000,
            step = 1,
            bigStep = 5,
            set = function(info, value)
                ns.db.profile.unitFrames.player.manaBar.height = value
                ns.BUFPlayer:SetManaSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.manaBar.height
            end,
            order = 2,
        },
        xOffset = {
            type = "range",
            name = ns.L["X Offset"],
            min = -500,
            softMin = -200,
            softMax = 200,
            max = 500,
            step = 1,
            bigStep = 5,
            set = function(info, value)
                ns.db.profile.unitFrames.player.manaBar.xOffset = value
                ns.BUFPlayer:SetManaPosition()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.manaBar.xOffset
            end,
            order = 3,
        },
        yOffset = {
            type = "range",
            name = ns.L["Y Offset"],
            min = -500,
            softMin = -200,
            softMax = 200,
            max = 500,
            step = 1,
            bigStep = 5,
            set = function(info, value)
                ns.db.profile.unitFrames.player.manaBar.yOffset = value
                ns.BUFPlayer:SetManaPosition()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.manaBar.yOffset
            end,
            order = 4,
        },
    },
}

BUFPlayer.ManaCoeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.dbDefaults.profile.unitFrames.player.manaBar.width),
    maskYOffset = 2 / ns.dbDefaults.profile.unitFrames.player.manaBar.height,
}

function BUFPlayer:SetManaSize()
    local width = ns.db.profile.unitFrames.player.manaBar.width
    local height = ns.db.profile.unitFrames.player.manaBar.height
    PixelUtil.SetWidth(self.manaBarArea, width, 18)
    PixelUtil.SetHeight(self.manaBarArea, height, 18)
    PixelUtil.SetWidth(self.manaBar, width, 18)
    PixelUtil.SetHeight(self.manaBar, height, 18)
    PixelUtil.SetWidth(self.manaBar.ManaBarMask, width * self.ManaCoeffs.maskWidth, 18)
    PixelUtil.SetHeight(self.manaBar.ManaBarMask, height * self.ManaCoeffs.maskHeight, 18)
    self.manaBar.ManaBarMask:SetPoint("TOPLEFT", width * self.ManaCoeffs.maskXOffset, 2 * self.ManaCoeffs.maskYOffset)
end

function BUFPlayer:SetManaPosition()
    local xOffset = ns.db.profile.unitFrames.player.manaBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.manaBar.yOffset
    self.manaBar:SetPoint("TOPLEFT", xOffset, yOffset)
end
