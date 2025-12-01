---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.PrestigePortrait: BUFScaleTexture
local BUFPlayerPrestigePortrait = {
    configPath = "unitFrames.player.prestigePortrait",
}

BUFPlayerPrestigePortrait.optionsTable = {
    type = "group",
    handler = BUFPlayerPrestigePortrait,
    name = ns.L["Prestige Portrait"],
    order = BUFPlayerIndicators.optionsOrder.PRESTIGE_PORTRAIT,
    args = {},
}

---@class BUFDbSchema.UF.Player.PrestigePortrait
BUFPlayerPrestigePortrait.dbDefaults = {
    scale = 1.0,
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = "TOPLEFT",
    xOffset = -2,
    yOffset = -38,
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerPrestigePortrait)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.prestigePortrait = BUFPlayerPrestigePortrait.dbDefaults

ns.options.args.player.args.indicators.args.prestigePortrait = BUFPlayerPrestigePortrait.optionsTable

function BUFPlayerPrestigePortrait:ToggleDemoMode()
    if self.demoMode then
        self.demoMode = false
        self.texture:Hide()
        self.secondaryTexture:Hide()
    else
        self.demoMode = true
        self.texture:SetAtlas("honorsystem-portrait-neutral", false)
        self.texture:Show()
        self.secondaryTexture:SetTexture("interface/pvpframe/icons/prestige-icon-1.blp")
        self.secondaryTexture:Show()
    end
end

function BUFPlayerPrestigePortrait:RefreshConfig()
    if not self.initialized then
        self.initialized = true
        self.defaultRelativeTo = BUFPlayer.contentContextual
        self.texture = BUFPlayer.contentContextual.PrestigePortrait
        self.secondaryTexture = BUFPlayer.contentContextual.PrestigeBadge
    end
    self:RefreshScaleTextureConfig()
end

function BUFPlayerPrestigePortrait:SetScaleFactor()
    self:_SetScaleFactor(self.texture)
    self:_SetScaleFactor(self.secondaryTexture)
end

BUFPlayerIndicators.PrestigePortrait = BUFPlayerPrestigePortrait
