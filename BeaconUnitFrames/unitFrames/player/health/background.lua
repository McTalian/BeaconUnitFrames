---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health
local BUFPlayerHealth = BUFPlayer.Health

---@class BUFPlayer.Health.Background: BackgroundTexturable, Colorable, ClassColorable
local backgroundHandler = {
    configPath = "unitFrames.player.healthBar.background",
}

BUFPlayerHealth.backgroundHandler = backgroundHandler

ns.Mixin(backgroundHandler, ns.BackgroundTexturable, ns.Colorable, ns.ClassColorable)

---@class BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = ns.dbDefaults.profile.unitFrames.player.healthBar

ns.dbDefaults.profile.unitFrames.player.healthBar.background = {
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
    order = BUFPlayerHealth.topGroupOrder.BACKGROUND,
    args = {}
}

ns.AddBackgroundTextureOptions(background.args)
ns.AddColorOptions(background.args)
ns.AddClassColorOptions(background.args)

ns.options.args.player.args.healthBar.args.background = background

function backgroundHandler:RefreshConfig()
    self:RefreshBackgroundTexture()
    self:RefreshColor()
end

function backgroundHandler:RefreshBackgroundTexture()
    local parent = ns.BUFPlayer
    local useBackgroundTexture = ns.db.profile.unitFrames.player.healthBar.background.useBackgroundTexture
    if useBackgroundTexture then
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND,
            ns.db.profile.unitFrames.player.healthBar.background.backgroundTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, "Solid") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.healthBar.Background:SetTexture(texturePath)
        parent.healthBar.Background:Show()
    end
end

function backgroundHandler:RefreshColor()
    local parent = ns.BUFPlayer
    local useCustomColor = ns.db.profile.unitFrames.player.healthBar.background.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.player.healthBar.background.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.healthBar.Background:SetVertexColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.player.healthBar.background.customColor)
        parent.healthBar.Background:SetVertexColor(r, g, b, a)
    end
end