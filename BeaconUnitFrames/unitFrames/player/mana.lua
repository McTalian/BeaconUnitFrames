---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Mana
local BUFPlayerMana = {}

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

local manaOrder = {
    WIDTH = 1,
    HEIGHT = 2,
    X_OFFSET = 3,
    Y_OFFSET = 4,
    FRAME_LEVEL = 5,
}

local manaBar = {
    type = "group",
    handler = BUFPlayerMana,
    name = MANA,
    order = BUFPlayer.optionsOrder.MANA,
    inline = true,
    args = {}
}

-- Add sizing options
ns.AddSizingOptions(manaBar.args, manaOrder)
ns.AddPositioningOptions(manaBar.args, manaOrder)
ns.AddFrameLevelOption(manaBar.args, manaOrder)

ns.options.args.unitFrames.args.player.args.manaBar = manaBar

-- Handler methods for mana bar options
function BUFPlayerMana:SetWidth(info, value)
    ns.db.profile.unitFrames.player.manaBar.width = value
    BUFPlayerMana:SetManaSize()
end

function BUFPlayerMana:GetWidth(info)
    return ns.db.profile.unitFrames.player.manaBar.width
end

function BUFPlayerMana:SetHeight(info, value)
    ns.db.profile.unitFrames.player.manaBar.height = value
    BUFPlayerMana:SetManaSize()
end

function BUFPlayerMana:GetHeight(info)
    return ns.db.profile.unitFrames.player.manaBar.height
end

function BUFPlayerMana:SetXOffset(info, value)
    ns.db.profile.unitFrames.player.manaBar.xOffset = value
    BUFPlayerMana:SetManaPosition()
end

function BUFPlayerMana:GetXOffset(info)
    return ns.db.profile.unitFrames.player.manaBar.xOffset
end

function BUFPlayerMana:SetYOffset(info, value)
    ns.db.profile.unitFrames.player.manaBar.yOffset = value
    BUFPlayerMana:SetManaPosition()
end

function BUFPlayerMana:GetYOffset(info)
    return ns.db.profile.unitFrames.player.manaBar.yOffset
end

BUFPlayerMana.coeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.dbDefaults.profile.unitFrames.player.manaBar.width),
    maskYOffset = 2 / ns.dbDefaults.profile.unitFrames.player.manaBar.height,
}

function BUFPlayerMana:RefreshConfig()
    self:SetManaPosition()
    self:SetManaSize()
end

function BUFPlayerMana:SetManaSize()
    local player = BUFPlayer
    local width = ns.db.profile.unitFrames.player.manaBar.width
    local height = ns.db.profile.unitFrames.player.manaBar.height
    PixelUtil.SetWidth(player.manaBarArea, width, 18)
    PixelUtil.SetHeight(player.manaBarArea, height, 18)
    PixelUtil.SetWidth(player.manaBar, width, 18)
    PixelUtil.SetHeight(player.manaBar, height, 18)
    PixelUtil.SetWidth(player.manaBar.ManaBarMask, width * self.coeffs.maskWidth, 18)
    PixelUtil.SetHeight(player.manaBar.ManaBarMask, height * self.coeffs.maskHeight, 18)
    player.manaBar.ManaBarMask:SetPoint("TOPLEFT", width * self.coeffs.maskXOffset, 2 * self.coeffs.maskYOffset)
end

function BUFPlayerMana:SetManaPosition()
    local player = BUFPlayer
    local xOffset = ns.db.profile.unitFrames.player.manaBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.manaBar.yOffset
    player.manaBar:SetPoint("TOPLEFT", xOffset, yOffset)
end
