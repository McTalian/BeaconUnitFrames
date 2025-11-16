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
    frameLevel = 3,
    useStatusBarTexture = false,
    statusBarTexture = "Blizzard",
    useBackgroundTexture = false,
    backgroundTexture = "",
    useCustomColor = false,
    customColor = { 0, 1, 0, 1 },
    useClassColor = false,
}

local healthBarOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    X_OFFSET = 3,
    Y_OFFSET = 4,
    FRAME_LEVEL = 5,
    FOREGROUND = 6,
    BACKGROUND = 7,
}

local foregroundOrder = {
    USE_STATUS_BAR_TEXTURE = 1,
    STATUS_BAR_TEXTURE = 2,
    USE_CUSTOM_COLOR = 3,
    CUSTOM_COLOR = 4,
    CLASS_COLOR = 5,
}

local backgroundOrder = {
    USE_BACKGROUND_TEXTURE = 1,
    BACKGROUND_TEXTURE = 2,
    USE_CUSTOM_COLOR = 3,
    CUSTOM_COLOR = 4,
    CLASS_COLOR = 5,
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
            order = healthBarOrder.WIDTH,
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
            order = healthBarOrder.HEIGHT,
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
            order = healthBarOrder.X_OFFSET,
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
            order = healthBarOrder.Y_OFFSET,
        },
        frameLevel = {
            type = "range",
            name = ns.L["Frame Level"],
            min = 0,
            max = 10000,
            step = 1,
            bigStep = 10,
            set = function(info, value)
                ns.db.profile.unitFrames.player.healthBar.frameLevel = value
                ns.BUFPlayer:SetHealthBarLevel()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.healthBar.frameLevel
            end,
            order = healthBarOrder.FRAME_LEVEL,
        },
        foreground = {
            type = "group",
            name = ns.L["Foreground"],
            inline = true,
            order = healthBarOrder.FOREGROUND,
            args = {
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
                    order = foregroundOrder.USE_STATUS_BAR_TEXTURE,
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
                    order = foregroundOrder.STATUS_BAR_TEXTURE,
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
                    order = foregroundOrder.USE_CUSTOM_COLOR,
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
                    order = foregroundOrder.CUSTOM_COLOR,
                },
                useClassColor = {
                    type = "toggle",
                    name = ns.L["Use Class Color"],
                    desc = ns.L["UseClassColorDesc"],
                    set = function(info, value)
                        ns.db.profile.unitFrames.player.healthBar.useClassColor = value
                        ns.BUFPlayer:SetHealthColor()
                    end,
                    get = function(info)
                        return ns.db.profile.unitFrames.player.healthBar.useClassColor
                    end,
                    order = foregroundOrder.CLASS_COLOR,
                },
            },
        },
        background = {
            type = "group",
            name = BACKGROUND,
            inline = true,
            order = healthBarOrder.BACKGROUND,
            args = {
                useBackgroundTexture = {
                    type = "toggle",
                    name = ns.L["Use Background Texture"],
                    desc = ns.L["UseBackgroundTextureDesc"],
                    set = function(info, value)
                        ns.db.profile.unitFrames.player.healthBar.useBackgroundTexture = value
                        ns.BUFPlayer:SetHealthBarBackgroundTexture()
                    end,
                    get = function(info)
                        return ns.db.profile.unitFrames.player.healthBar.useBackgroundTexture
                    end,
                    order = backgroundOrder.USE_BACKGROUND_TEXTURE,
                },
                backgroundTexture = {
                    type = "select",
                    name = ns.L["Background Texture"],
                    dialogControl = "LSM30_Background",
                    values = function()
                        return ns.lsm:HashTable(ns.lsm.MediaType.BACKGROUND)
                    end,
                    disabled = function()
                        return ns.db.profile.unitFrames.player.healthBar.useBackgroundTexture == false
                    end,
                    set = function(info, value)
                        ns.db.profile.unitFrames.player.healthBar.backgroundTexture = value
                        ns.BUFPlayer:SetHealthBarBackgroundTexture()
                    end,
                    get = function(info)
                        return ns.db.profile.unitFrames.player.healthBar.backgroundTexture
                    end,
                    order = backgroundOrder.BACKGROUND_TEXTURE,
                },
            },
        },
    },
}

BUFPlayer.HealthCoeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.dbDefaults.profile.unitFrames.player.healthBar.width),
    maskYOffset = 6 / ns.dbDefaults.profile.unitFrames.player.healthBar.height,
}

function BUFPlayer:RefreshHealthConfig()
    self:SetHealthPosition()
    self:SetHealthSize()
    self:SetHealthStatusBarTexture()
    self:SetHealthBarLevel()
    self:SetHealthColor()
    self:SetHealthBarBackgroundTexture()
end

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

function BUFPlayer:SetHealthBarLevel()
    local frameLevel = ns.db.profile.unitFrames.player.healthBar.frameLevel
    self.healthBar:SetFrameLevel(frameLevel)
end

function BUFPlayer:SetHealthStatusBarTexture()
    local useCustomTexture = ns.db.profile.unitFrames.player.healthBar.useStatusBarTexture
    if useCustomTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, ns.db.profile.unitFrames.player.healthBar.statusBarTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
        end
        self.healthBar:SetStatusBarTexture(texturePath)
        self:SetHealthBarLevel()
    end
end

function BUFPlayer:SetHealthColor()
    local useCustomColor = ns.db.profile.unitFrames.player.healthBar.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.player.healthBar.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        self.healthBar:SetStatusBarColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.customColor)
        self.healthBar:SetStatusBarColor(r, g, b, a)
    end
end

function BUFPlayer:SetHealthBarBackgroundTexture()
    local useBackgroundTexture = ns.db.profile.unitFrames.player.healthBar.useBackgroundTexture
    if useBackgroundTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, ns.db.profile.unitFrames.player.healthBar.backgroundTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, "Solid") or "Interface\\Buttons\\WHITE8x8"
        end
        self.healthBar.Background:SetTexture(texturePath)
        self.healthBar.Background:Show()
    end
end
