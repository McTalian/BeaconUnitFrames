---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.Background: BUFConfigHandler, BackgroundTexturable, Colorable, ClassColorable
local backgroundHandler = {
    configPath = "unitFrames.target.powerBar.background",
}

BUFTargetPower.backgroundHandler = backgroundHandler

ns.Mixin(backgroundHandler, ns.BackgroundTexturable, ns.Colorable, ns.ClassColorable)

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.background = {
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
    order = BUFTargetPower.topGroupOrder.BACKGROUND,
    args = {}
}

ns.AddBackgroundTextureOptions(background.args)
ns.AddColorOptions(background.args)
ns.AddClassColorOptions(background.args)

ns.options.args.unitFrames.args.target.args.powerBar.args.background = background

function backgroundHandler:RefreshConfig()
    self:RefreshBackgroundTexture()
    self:RefreshColor()
end

function backgroundHandler:CreateBackgroundTexture()
    if not ns.BUFTarget.manaBar.Background then
---@diagnostic disable-next-line: inject-field
        ns.BUFTarget.manaBar.Background = ns.BUFTarget.manaBar:CreateTexture(nil, "BACKGROUND")
        ns.BUFTarget.manaBar.Background:SetAllPoints(ns.BUFTarget.manaBar)
        ns.BUFTarget.manaBar.Background:SetDrawLayer("BACKGROUND", 2)
        ns.BUFTarget.manaBar.Background:SetVertexColor(0, 0, 0, 1)
    end
end

function backgroundHandler:RefreshBackgroundTexture()
    local parent = ns.BUFTarget
    local useBackgroundTexture = ns.db.profile.unitFrames.target.powerBar.background.useBackgroundTexture
    if useBackgroundTexture then
        self:CreateBackgroundTexture()
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND,
            ns.db.profile.unitFrames.target.powerBar.background.backgroundTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, "Solid") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.manaBar.Background:SetTexture(texturePath)
        parent.manaBar.Background:Show()
    end
end

function backgroundHandler:RefreshColor()
    local parent = ns.BUFTarget
    local useCustomColor = ns.db.profile.unitFrames.target.powerBar.background.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.target.powerBar.background.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.manaBar.Background:SetVertexColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.background.customColor)
        parent.manaBar.Background:SetVertexColor(r, g, b, a)
    end
end