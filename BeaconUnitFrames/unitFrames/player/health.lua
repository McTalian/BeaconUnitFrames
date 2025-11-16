---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = {
    width = 124,
    height = 20,
    xOffset = 85,
    yOffset = -40,
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useCustomColor = false,
    customColor = { 0, 1, 0, 1 },
}

ns.options.args.unitFrames.args.player.args.healthBar = {
    type = "group",
    name = HEALTH,
    order = BUFPlayer.optionsOrder.HEALTH,
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
                ns.db.profile.unitFrames.player.healthBar.width = value
                ns.BUFPlayer:SetHealthSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.healthBar.width
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
                ns.db.profile.unitFrames.player.healthBar.height = value
                ns.BUFPlayer:SetHealthSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.healthBar.height
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
                ns.db.profile.unitFrames.player.healthBar.xOffset = value
                ns.BUFPlayer:SetHealthPosition()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.healthBar.xOffset
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
                ns.db.profile.unitFrames.player.healthBar.yOffset = value
                ns.BUFPlayer:SetHealthPosition()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.healthBar.yOffset
            end,
            order = 4,
        },
        useStatusBarTexture = {
            type = "toggle",
            name = ns.L["Use Status Bar Texture"],
            desc = ns.L["UseStatusBarTextureDesc"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture = value
                ns.BUFPlayer:SetHealthStatusBarTexture()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture
            end,
            order = 5,
        },
        statusBarTexture = {
            type = "select",
            name = ns.L["Status Bar Texture"],
            dialogControl = "LSM30_Statusbar",
            values = function()
                return ns.lsm:HashTable(ns.lsm.MediaType.STATUSBAR)
            end,
            disabled = function()
                return ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture == false
            end,
            set = function(info, value)
                ns.db.profile.unitFrames.player.healthBar.statusBarTexture = value
                ns.BUFPlayer:SetHealthStatusBarTexture()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.healthBar.statusBarTexture
            end,
            order = 6,
        },
        useCustomColor = {
            type = "toggle",
            name = ns.L["Use Custom Color"],
            desc = ns.L["UseCustomColorDesc"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.healthBar.useCustomColor = value
                ns.BUFPlayer:SetHealthColor()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.healthBar.useCustomColor
            end,
            order = 7,
        },
        customColor = {
            type = "color",
            name = ns.L["Custom Color"],
            hasAlpha = true,
            disabled = function()
                return ns.db.profile.unitFrames.player.healthBar.useCustomColor == false
            end,
            set = function(info, r, g, b, a)
                ns.db.profile.unitFrames.player.healthBar.customColor = { r, g, b, a }
                ns.BUFPlayer:SetHealthColor()
            end,
            get = function(info)
                local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.customColor)
                return r, g, b, a
            end,
            order = 8,
        },
    },
}

BUFPlayer.HealthCoeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.dbDefaults.profile.unitFrames.player.healthBar.width),
    maskYOffset = 6 / ns.dbDefaults.profile.unitFrames.player.healthBar.height,
}

function BUFPlayer:SetHealthSize()
    local width = ns.db.profile.unitFrames.player.healthBar.width
    local height = ns.db.profile.unitFrames.player.healthBar.height
    PixelUtil.SetWidth(self.healthBarContainer, width, 18)
    PixelUtil.SetHeight(self.healthBarContainer, height, 18)
    PixelUtil.SetWidth(self.healthBar, width, 18)
    PixelUtil.SetHeight(self.healthBar, height, 18)
    PixelUtil.SetWidth(self.healthBarContainer.HealthBarMask, width * self.HealthCoeffs.maskWidth, 18)
    PixelUtil.SetHeight(self.healthBarContainer.HealthBarMask, height * self.HealthCoeffs.maskHeight, 18)
    self.healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", width * self.HealthCoeffs.maskXOffset, 6 * self.HealthCoeffs.maskYOffset)
end

function BUFPlayer:SetHealthPosition()
    local xOffset = ns.db.profile.unitFrames.player.healthBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.yOffset
    self.healthBarContainer:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayer:SetHealthStatusBarTexture()
    local useCustomTexture = ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture
    if useCustomTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, ns.db.profile.unitFrames.player.healthBar.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        self.healthBar:SetStatusBarTexture(texturePath)
    end
end

function BUFPlayer:SetHealthColor()
    local useCustomColor = ns.db.profile.unitFrames.player.healthBar.useCustomColor
    if useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.customColor)
        self.healthBar:SetStatusBarColor(r, g, b, a)
    end
end
