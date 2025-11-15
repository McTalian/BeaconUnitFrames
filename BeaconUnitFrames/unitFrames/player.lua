---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer: AceModule, AceHook-3.0
ns.BUFPlayer = ns.BUF:NewModule("BUFPlayer", "AceHook-3.0")

local function noop() end

local frame = PlayerFrame
local container = frame.PlayerFrameContainer
local content = frame.PlayerFrameContent
local contentMain = content.PlayerFrameContentMain
local contentContextual = PlayerFrame_GetPlayerFrameContentContextual()
local restLoop = contentContextual.PlayerRestLoop
local healthBarContainer = PlayerFrame_GetHealthBarContainer()
local healthBar = PlayerFrame_GetHealthBar()
local manaBarArea = contentMain.ManaBarArea
local manaBar = PlayerFrame_GetManaBar()
local altPowerBar = PlayerFrame_GetAlternatePowerBar()

function ns.BUFPlayer:RefreshConfig()
    self:SetFrameSize()
    self:ShowHidePortrait()
    self:SetHealthPosition()
    self:SetHealthSize()
    self:SetManaPosition()
    self:SetManaSize()
end

function ns.BUFPlayer:SetFrameSize()
    local width = ns.db.profile.unitFrames.player.frame.width
    local height = ns.db.profile.unitFrames.player.frame.height
    PixelUtil.SetWidth(frame, width, 18)
    PixelUtil.SetHeight(frame, height, 18)
end

function ns.BUFPlayer:ShowHidePortrait()
    local show = ns.db.profile.unitFrames.player.portrait.enabled
    if show then
        self:Unhook(container.PlayerPortrait, "Show")
        self:Unhook(container.PlayerPortraitMask, "Show")
        self:Unhook(container.FrameTexture, "Show")
        self:Unhook(contentContextual.PlayerPortraitCornerIcon, "Show")
        self:Unhook(contentMain.StatusTexture, "Show")
        container.PlayerPortrait:Show()
        container.PlayerPortraitMask:Show()
        container.FrameTexture:Show()
        contentContextual.PlayerPortraitCornerIcon:Show()
        contentMain.StatusTexture:Show()
        PlayerName:SetPoint("TOPLEFT", 88, -27)
        restLoop:SetPoint("TOPLEFT", 64, -6)
    else
        container.PlayerPortrait:Hide()
        container.PlayerPortraitMask:Hide()
        container.FrameTexture:Hide()
        contentContextual.PlayerPortraitCornerIcon:Hide()
        contentMain.StatusTexture:Hide()
        self:RawHook(container.PlayerPortrait, "Show", noop, true)
        self:RawHook(container.PlayerPortraitMask, "Show", noop, true)
        self:RawHook(container.FrameTexture, "Show", noop, true)
        self:RawHook(contentContextual.PlayerPortraitCornerIcon, "Show", noop, true)
        self:RawHook(contentMain.StatusTexture, "Show", noop, true)
        PlayerName:SetPoint("TOPLEFT", 3, -27)
        restLoop:SetPoint("TOPLEFT", -2, -6)
    end
end

ns.BUFPlayer.HealthCoeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.DbManager.dbDefaults.profile.unitFrames.player.healthBar.width),
    maskYOffset = 6 / ns.DbManager.dbDefaults.profile.unitFrames.player.healthBar.height,
}

function ns.BUFPlayer:SetHealthSize()
    local width = ns.db.profile.unitFrames.player.healthBar.width
    local height = ns.db.profile.unitFrames.player.healthBar.height
    -- print("Setting health bar size to:", width, height)
    PixelUtil.SetWidth(healthBarContainer, width, 18)
    PixelUtil.SetHeight(healthBarContainer, height, 18)
    PixelUtil.SetWidth(healthBar, width, 18)
    PixelUtil.SetHeight(healthBar, height, 18)
    PixelUtil.SetWidth(healthBarContainer.HealthBarMask, width * self.HealthCoeffs.maskWidth, 18)
    PixelUtil.SetHeight(healthBarContainer.HealthBarMask, height * self.HealthCoeffs.maskHeight, 18)
    healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", width * self.HealthCoeffs.maskXOffset, 6 * self.HealthCoeffs.maskYOffset)
end

function ns.BUFPlayer:SetHealthPosition()
    local xOffset = ns.db.profile.unitFrames.player.healthBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.healthBar.yOffset
    healthBarContainer:SetPoint("TOPLEFT", xOffset, yOffset)
end

ns.BUFPlayer.ManaCoeffs = {
    maskWidth = 1.05,
    maskHeight = 1.0,
    maskXOffset = (-2 / ns.DbManager.dbDefaults.profile.unitFrames.player.manaBar.width),
    maskYOffset = 2 / ns.DbManager.dbDefaults.profile.unitFrames.player.manaBar.height,
}

function ns.BUFPlayer:SetManaSize()
    local width = ns.db.profile.unitFrames.player.manaBar.width
    local height = ns.db.profile.unitFrames.player.manaBar.height
    PixelUtil.SetWidth(manaBarArea, width, 18)
    PixelUtil.SetHeight(manaBarArea, height, 18)
    PixelUtil.SetWidth(manaBar, width, 18)
    PixelUtil.SetHeight(manaBar, height, 18)
    PixelUtil.SetWidth(manaBar.ManaBarMask, width * self.ManaCoeffs.maskWidth, 18)
    PixelUtil.SetHeight(manaBar.ManaBarMask, height * self.ManaCoeffs.maskHeight, 18)
    manaBar.ManaBarMask:SetPoint("TOPLEFT", width * self.ManaCoeffs.maskXOffset, 2 * self.ManaCoeffs.maskYOffset)
end

function ns.BUFPlayer:SetManaPosition()
    local xOffset = ns.db.profile.unitFrames.player.manaBar.xOffset
    local yOffset = ns.db.profile.unitFrames.player.manaBar.yOffset
    manaBar:SetPoint("TOPLEFT", xOffset, yOffset)
end

-- local BUF = _G.BeaconUnitFrames
-- local t = BUF.lsm:Fetch("statusbar", "Blizzard")
-- local hb = PlayerFrame_GetHealthBar()
-- hb:SetStatusBarTexture(t)
-- local _, c = UnitClass("player")
-- local r,g,b,hex = GetClassColor(c)
-- hb:SetStatusBarColor(r, g, b, 1.0)

-- PlayerName:ClearAllPoints()
-- PlayerName:SetPoint("BOTTOMLEFT", healthBarContainer, "TOPLEFT", 4, 1)
-- PlayerLevelText:ClearAllPoints()
-- PlayerLevelText:SetPoint("BOTTOMRIGHT", healthBarContainer, "TOPRIGHT", -4, 1)

-- restLoop.RestTexture:ClearAllPoints()
-- restLoop.RestTexture:SetPoint("BOTTOMLEFT", PlayerLevelText, "TOPRIGHT")
