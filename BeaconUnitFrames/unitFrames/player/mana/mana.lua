---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Mana: BUFConfigHandler, Positionable, Sizable, Levelable
local BUFPlayerMana = {
    configPath = "unitFrames.player.manaBar",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerMana)
ns.ApplyMixin(ns.Sizable, BUFPlayerMana)
ns.ApplyMixin(ns.Levelable, BUFPlayerMana)

BUFPlayer.Mana = BUFPlayerMana

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Mana
ns.dbDefaults.profile.unitFrames.player.manaBar = {
    width = 124,
    height = 10,
    xOffset = 85,
    yOffset = -61,
    frameLevel = 3,
}

local manaBarOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    X_OFFSET = 3,
    Y_OFFSET = 4,
    FRAME_LEVEL = 5,
    LEFT_TEXT = 6,
    RIGHT_TEXT = 7,
    CENTER_TEXT = 8,
    FOREGROUND = 9,
    BACKGROUND = 10,
}

BUFPlayerMana.topGroupOrder = manaBarOrder

local textOrder = {
    ANCHOR_POINT = 1,
    X_OFFSET = 2,
    Y_OFFSET = 3,
    USE_FONT_OBJECTS = 4,
    FONT_OBJECT = 5,
    FONT_COLOR = 6,
    FONT_FACE = 7,
    FONT_SIZE = 8,
    FONT_FLAGS = 9,
    FONT_SHADOW_COLOR = 10,
    FONT_SHADOW_OFFSET_X = 11,
    FONT_SHADOW_OFFSET_Y = 12,
}

BUFPlayerMana.textOrder = textOrder

local manaBar = {
    type = "group",
    handler = BUFPlayerMana,
    name = MANA,
    order = BUFPlayer.optionsOrder.MANA,
    childGroups = "tab",
    args = {},
}

ns.AddSizingOptions(manaBar.args, manaBarOrder)
ns.AddPositioningOptions(manaBar.args, manaBarOrder)
ns.AddFrameLevelOption(manaBar.args, manaBarOrder)

ns.options.args.unitFrames.args.player.args.manaBar = manaBar

BUFPlayerMana.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.dbDefaults.profile.unitFrames.player.manaBar.width),
    maskYOffset = 2 / ns.dbDefaults.profile.unitFrames.player.manaBar.height,
}

function BUFPlayerMana:RefreshConfig()
    self:SetPosition()
    self:SetSize()
    self:SetLevel()
    self.leftTextHandler:RefreshConfig()
    self.rightTextHandler:RefreshConfig()
    self.centerTextHandler:RefreshConfig()
    self.foregroundHandler:RefreshConfig()
    self.backgroundHandler:RefreshConfig()
end

function BUFPlayerMana:SetSize()
    local parent = BUFPlayer
    local width = ns.db.profile.unitFrames.player.manaBar.width
    local height = ns.db.profile.unitFrames.player.manaBar.height
    PixelUtil.SetWidth(parent.manaBar, width, 18)
    PixelUtil.SetHeight(parent.manaBar, height, 18)
    PixelUtil.SetWidth(parent.manaBar.ManaBarMask, width * self.coeffs.maskWidth, 18)
    PixelUtil.SetHeight(parent.manaBar.ManaBarMask, height * self.coeffs.maskHeight, 18)
    parent.manaBar.ManaBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset, height * self.coeffs.maskYOffset)
end

function BUFPlayerMana:SetPosition()
    local parent = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.manaBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.manaBar.yOffset
    parent.manaBar:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerMana:SetLevel()
    local parent = BUFPlayer
    local frameLevel = ns.db.profile.unitFrames.player.manaBar.frameLevel
    parent.manaBar:SetUsingParentLevel(false)
    parent.manaBar:SetFrameLevel(frameLevel)
end