---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power
local BUFPetPower = BUFPet.Power

---@class BUFPet.Power.Background: BUFConfigHandler, BackgroundTexturable, Colorable, ClassColorable
local backgroundHandler = {
    configPath = "unitFrames.pet.powerBar.background",
}

BUFPetPower.backgroundHandler = backgroundHandler

ns.Mixin(backgroundHandler, ns.BackgroundTexturable, ns.Colorable, ns.ClassColorable)

---@class BUFDbSchema.UF.Pet.Power
ns.dbDefaults.profile.unitFrames.pet.powerBar = ns.dbDefaults.profile.unitFrames.pet.powerBar

ns.dbDefaults.profile.unitFrames.pet.powerBar.background = {
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
    order = BUFPetPower.topGroupOrder.BACKGROUND,
    args = {}
}

ns.AddBackgroundTextureOptions(background.args)
ns.AddColorOptions(background.args)
ns.AddClassColorOptions(background.args)

ns.options.args.pet.args.powerBar.args.background = background

function backgroundHandler:RefreshConfig()
    self:RefreshBackgroundTexture()
    self:RefreshColor()
end

function backgroundHandler:CreateBackgroundTexture()
    if not ns.BUFPet.manaBar.Background then
---@diagnostic disable-next-line: inject-field
        ns.BUFPet.manaBar.Background = ns.BUFPet.manaBar:CreateTexture(nil, "BACKGROUND")
        ns.BUFPet.manaBar.Background:SetAllPoints(ns.BUFPet.manaBar)
        ns.BUFPet.manaBar.Background:SetDrawLayer("BACKGROUND", 2)
        ns.BUFPet.manaBar.Background:SetVertexColor(0, 0, 0, 1)
    end
end

function backgroundHandler:RefreshBackgroundTexture()
    local parent = ns.BUFPet
    local useBackgroundTexture = ns.db.profile.unitFrames.pet.powerBar.background.useBackgroundTexture
    if useBackgroundTexture then
        self:CreateBackgroundTexture()
        local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND,
            ns.db.profile.unitFrames.pet.powerBar.background.backgroundTexture)
        if not texturePath then
            texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, "Solid") or "Interface\\Buttons\\WHITE8x8"
        end
        parent.manaBar.Background:SetTexture(texturePath)
        parent.manaBar.Background:Show()
    end
end

function backgroundHandler:RefreshColor()
    local parent = ns.BUFPet
    local useCustomColor = ns.db.profile.unitFrames.pet.powerBar.background.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.pet.powerBar.background.useClassColor
    if useClassColor then
        local _, class = UnitClass("player")
        local r, g, b = GetClassColor(class)
        parent.manaBar.Background:SetVertexColor(r, g, b, 1.0)
    elseif useCustomColor then
        local r, g, b, a = unpack(ns.db.profile.unitFrames.pet.powerBar.background.customColor)
        parent.manaBar.Background:SetVertexColor(r, g, b, a)
    end
end