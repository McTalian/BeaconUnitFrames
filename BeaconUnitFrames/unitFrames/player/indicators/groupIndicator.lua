---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.GroupIndicator: Positionable, Fontable, BackgroundTexturable, Colorable, Demoable
local BUFPlayerGroupIndicator = {
    configPath = "unitFrames.player.groupIndicator",
}

ns.Mixin(BUFPlayerGroupIndicator, ns.Positionable, ns.Fontable, ns.BackgroundTexturable, ns.Colorable, ns.Demoable)

BUFPlayerIndicators.GroupIndicator = BUFPlayerGroupIndicator

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.GroupIndicator
ns.dbDefaults.profile.unitFrames.player.groupIndicator = {
    xOffset = 210,
    yOffset = -29,
    useFontObjects = true,
    fontObject = "GameFontNormalSmall",
    fontColor = { 1, 1, 1, 1 },
    fontFace = "Friz Quadrata TT",
    fontSize = 12,
    fontFlags = {
        [ns.FontFlags.OUTLINE] = false,
        [ns.FontFlags.THICKOUTLINE] = false,
        [ns.FontFlags.MONOCHROME] = false,
    },
    fontShadowColor = { 0, 0, 0, 1 },
    fontShadowOffsetX = 1,
    fontShadowOffsetY = -1,
    useBackgroundTexture = false,
    backgroundTexture = "None",
    useCustomColor = false,
    customColor = { 0, 0, 0, 0.5 },
}

local groupIndicator = {
    type = "group",
    handler = BUFPlayerGroupIndicator,
    name = ns.L["GroupIndicator"],
    order = BUFPlayerIndicators.optionsOrder.GROUP_INDICATOR,
    args = {}
}

ns.AddPositionableOptions(groupIndicator.args)
ns.AddFontOptions(groupIndicator.args)
ns.AddBackgroundTextureOptions(groupIndicator.args)
ns.AddColorOptions(groupIndicator.args)
ns.AddDemoOptions(groupIndicator.args)

ns.options.args.player.args.indicators.args.groupIndicator = groupIndicator

function BUFPlayerGroupIndicator:ToggleDemoMode()
    local grpInd = BUFPlayer.contentContextual.GroupIndicator
    if self.demoMode then
        self.demoMode = false
        grpInd:Hide()
    else
        self.demoMode = true
        PlayerFrameGroupIndicatorText:SetText(GROUP.." "..1);
        grpInd:SetWidth(PlayerFrameGroupIndicatorText:GetWidth() + 40);
        grpInd:Show()
    end
end

function BUFPlayerGroupIndicator:RefreshConfig()
    self:SetPosition()
    self:SetFont()
    self:SetFontShadow()
    self:RefreshBackgroundTexture()
end

function BUFPlayerGroupIndicator:SetPosition()
    local grpInd = BUFPlayer.contentContextual.GroupIndicator
    local xOffset = ns.db.profile.unitFrames.player.groupIndicator.xOffset
    local yOffset = ns.db.profile.unitFrames.player.groupIndicator.yOffset
    grpInd:SetPoint("BOTTOMRIGHT", BUFPlayer.contentContextual, "TOPLEFT", xOffset, yOffset)
end

function BUFPlayerGroupIndicator:SetFont()
    local grpIndText = PlayerFrameGroupIndicatorText
    local useFontObjects = ns.db.profile.unitFrames.player.groupIndicator.useFontObjects
    if useFontObjects then
        local fontObject = ns.db.profile.unitFrames.player.groupIndicator.fontObject
        grpIndText:SetFontObject(_G[fontObject])
    else
        local fontFace = ns.db.profile.unitFrames.player.groupIndicator.fontFace
        local fontPath = ns.lsm:Fetch(ns.lsm.MediaType.FONT, fontFace)
        if not fontPath then
            fontPath = STANDARD_TEXT_FONT
        end
        local fontSize = ns.db.profile.unitFrames.player.groupIndicator.fontSize
        local fontFlags = ns.FontFlagsToString(ns.db.profile.unitFrames.player.groupIndicator.fontFlags)
        grpIndText:SetFont(fontPath, fontSize, fontFlags)
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.groupIndicator.fontColor)
    grpIndText:SetTextColor(r, g, b, a)
end

function BUFPlayerGroupIndicator:SetFontShadow()
    local grpIndText = PlayerFrameGroupIndicatorText
    local useFontObjects = ns.db.profile.unitFrames.player.groupIndicator.useFontObjects
    if useFontObjects then
        -- Font objects handle shadow internally
        return
    end
    local r, g, b, a = unpack(ns.db.profile.unitFrames.player.groupIndicator.fontShadowColor)
    local offsetX = ns.db.profile.unitFrames.player.groupIndicator.fontShadowOffsetX
    local offsetY = ns.db.profile.unitFrames.player.groupIndicator.fontShadowOffsetY
    grpIndText:SetShadowColor(r, g, b, a)
    grpIndText:SetShadowOffset(offsetX, offsetY)
end

function BUFPlayerGroupIndicator:RefreshBackgroundTexture()
    local grpInd = BUFPlayer.contentContextual.GroupIndicator
    local useBackgroundTexture = ns.db.profile.unitFrames.player.groupIndicator.useBackgroundTexture

    local show
    local regions = { grpInd:GetRegions() }
    if not useBackgroundTexture then
        show = grpInd:IsShown()
    else
        show = false
    end
    for i,v in ipairs(regions) do
        local region = v
        if
            region and
            region ~= grpInd and
            region ~= self.background and
            region:GetObjectType() == "Texture"
        then
            region:SetShown(show)
        end
    end
    if not useBackgroundTexture then
        if self.background then
            self.background:Hide()
        end
        return
    end

    local backgroundTexture = ns.db.profile.unitFrames.player.groupIndicator.backgroundTexture
    local bgTexturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, backgroundTexture)
    if not bgTexturePath then
        bgTexturePath = "Interface/None"
    end
    if not self.background then
        self.background = grpInd:CreateTexture(nil, "BACKGROUND")
    end
    self.background:SetAllPoints(grpInd)
    self.background:SetTexture(bgTexturePath)
    self.background:Show()
end
