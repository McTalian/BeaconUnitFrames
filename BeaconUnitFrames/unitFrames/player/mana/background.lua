---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Mana
local BUFPlayerMana = BUFPlayer.Mana

---@class BUFPlayer.Mana.Background: BUFConfigHandler, BackgroundTexturable, Colorable
local backgroundHandler = {
    configPath = "unitFrames.player.manaBar.background",
}

BUFPlayerMana.backgroundHandler = backgroundHandler

ns.ApplyMixin(ns.BackgroundTexturable, backgroundHandler)
ns.ApplyMixin(ns.Colorable, backgroundHandler)

---@class BUFDbSchema.UF.Player.Mana
ns.dbDefaults.profile.unitFrames.player.manaBar = ns.dbDefaults.profile.unitFrames.player.manaBar

ns.dbDefaults.profile.unitFrames.player.manaBar.background = {
    useBackgroundTexture = false,
    backgroundTexture = "None",
    useCustomColor = false,
    customColor = { 0, 0, 0, 0.5 },
    useClassColor = false,
}

local backgroundOrder = {
    USE_BACKGROUND_TEXTURE = 1,
    BACKGROUND_TEXTURE = 2,
    USE_CUSTOM_COLOR = 3,
    CUSTOM_COLOR = 4,
    CLASS_COLOR = 5,
}

local background = {
    type = "group",
    handler = backgroundHandler,
    name = BACKGROUND,
    order = BUFPlayerMana.topGroupOrder.BACKGROUND,
    args = {}
}

ns.AddBackgroundTextureOptions(background.args, backgroundOrder)
ns.AddColorOptions(background.args, backgroundOrder)

ns.options.args.unitFrames.args.player.args.manaBar.args.background = background

function backgroundHandler:RefreshConfig()
    self:RefreshBackgroundTexture()
    self:RefreshColor()
end

function backgroundHandler:RefreshBackgroundTexture()
    local parent = ns.BUFPlayer
    local useBackgroundTexture = ns.db.profile.unitFrames.player.manaBar.background.useBackgroundTexture
    if useBackgroundTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND,
            ns.db.profile.unitFrames.player.manaBar.background.backgroundTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, "Solid") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.manaBar.Background:SetTexture(texturePath)
        parent.manaBar.Background:Show()
    end
end

function backgroundHandler:RefreshColor()
    local parent = ns.BUFPlayer
    local useCustomColor = ns.db.profile.unitFrames.player.manaBar.background.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.player.manaBar.background.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.manaBar.Background:SetVertexColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.manaBar.background.customColor)
        parent.manaBar.Background:SetVertexColor(r, g, b, a)
    end
end