---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power
local BUFPlayerPower = BUFPlayer.Power

---@class BUFPlayer.Power.Background: BackgroundTexturable, Colorable, ClassColorable
local backgroundHandler = {
    configPath = "unitFrames.player.powerBar.background",
}

BUFPlayerPower.backgroundHandler = backgroundHandler

ns.Mixin(backgroundHandler, ns.BackgroundTexturable, ns.Colorable, ns.ClassColorable)

---@class BUFDbSchema.UF.Player.Power
ns.dbDefaults.profile.unitFrames.player.powerBar = ns.dbDefaults.profile.unitFrames.player.powerBar

ns.dbDefaults.profile.unitFrames.player.powerBar.background = {
    useBackgroundTexture = false,
    backgroundTexture = "None",
    useCustomColor = false,
    customColor = { 0, 0, 0, 0.5 },
    useClassColor = false,
}

local background = {
    type = "group",
    handler = backgroundHandler,
    name = BACKGROUND,
    order = BUFPlayerPower.topGroupOrder.BACKGROUND,
    args = {}
}

ns.AddBackgroundTextureOptions(background.args)
ns.AddColorOptions(background.args)
ns.AddClassColorOptions(background.args)

ns.options.args.player.args.powerBar.args.background = background

function backgroundHandler:RefreshConfig()
    self:RefreshBackgroundTexture()
    self:RefreshColor()
end

function backgroundHandler:CreateBackgroundTexture()
    if not ns.BUFPlayer.manaBar.Background then
---@diagnostic disable-next-line: inject-field
        ns.BUFPlayer.manaBar.Background = ns.BUFPlayer.manaBar:CreateTexture(nil, "BACKGROUND")
        ns.BUFPlayer.manaBar.Background:SetAllPoints(ns.BUFPlayer.manaBar)
        ns.BUFPlayer.manaBar.Background:SetDrawLayer("BACKGROUND", 2)
        ns.BUFPlayer.manaBar.Background:SetVertexColor(0, 0, 0, 1)
    end
end

function backgroundHandler:RefreshBackgroundTexture()
    local parent = ns.BUFPlayer
    local useBackgroundTexture = ns.db.profile.unitFrames.player.powerBar.background.useBackgroundTexture
    if useBackgroundTexture then
        self:CreateBackgroundTexture()
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND,
            ns.db.profile.unitFrames.player.powerBar.background.backgroundTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, "Solid") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.manaBar.Background:SetTexture(texturePath)
        parent.manaBar.Background:Show()
    end
end

function backgroundHandler:RefreshColor()
    local parent = ns.BUFPlayer
    local useCustomColor = ns.db.profile.unitFrames.player.powerBar.background.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.player.powerBar.background.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.manaBar.Background:SetVertexColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.powerBar.background.customColor)
        parent.manaBar.Background:SetVertexColor(r, g, b, a)
    end
end