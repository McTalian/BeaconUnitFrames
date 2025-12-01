---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Portrait: Sizable, Positionable, BoxMaskable
local BUFPetPortrait = {
    configPath = "unitFrames.pet.portrait",
}

ns.Mixin(BUFPetPortrait, ns.Sizable, ns.Positionable, ns.BoxMaskable)

BUFPet.Portrait = BUFPetPortrait

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

---@class BUFDbSchema.UF.Pet.Portrait
ns.dbDefaults.profile.unitFrames.pet.portrait = {
    enabled = true,
    width = 37,
    height = 37,
    scale = 1,
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 5,
    yOffset = -5,
    mask = "CircleMaskScalable",
    maskWidthScale = 1,
    maskHeightScale = 1,
    alpha = 1.0,
}

local portrait = {
    type = "group",
    handler = BUFPetPortrait,
    name = ns.L["Portrait"],
    order = BUFPet.optionsOrder.PORTRAIT,
    args = {
        enabled = {
            type = "toggle",
            name = ENABLE,
            desc = ns.L["EnablePlayerPortrait"],
            set = function(info, value)
                ns.db.profile.unitFrames.pet.portrait.enabled = value
                BUFPetPortrait:ShowHidePortrait()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.pet.portrait.enabled
            end,
            order = ns.defaultOrderMap.ENABLE,
        },
    },
}

ns.AddSizableOptions(portrait.args)
ns.AddPositionableOptions(portrait.args)
ns.AddBoxMaskableOptions(portrait.args)

ns.options.args.pet.args.portrait = portrait

function BUFPetPortrait:RefreshConfig()
    if not self.initialized then
        self.initialized = true

        self.defaultRelativeTo = PetFrame
        self.defaultRelativePoint = "TOPLEFT"
    end

    self:ShowHidePortrait()
    self:SetPosition()
    self:SetSize()
end

function BUFPetPortrait:SetSize()
    self:_SetSize(PetPortrait)
    self:RefreshMask()
end

function BUFPetPortrait:SetPosition()
    self:_SetPosition(PetPortrait)
end

function BUFPetPortrait:ShowHidePortrait()
    local parent = BUFPet
    local show = ns.db.profile.unitFrames.pet.portrait.enabled
    if show then
        if parent:IsHooked(PetPortrait, "Show") then
            parent:Unhook(PetPortrait, "Show")
        end
        if parent:IsHooked(parent.frame.PortraitMask, "Show") then
            parent:Unhook(parent.frame.PortraitMask, "Show")
        end
        PetPortrait:Show()
        parent.frame.PortraitMask:Show()
    else
        PetPortrait:Hide()
        parent.frame.PortraitMask:Hide()
        if not ns.BUFPet:IsHooked(PetPortrait, "Show") then
            parent:SecureHook(PetPortrait, "Show", function(s)
                s:Hide()
            end)
        end
        if not ns.BUFPet:IsHooked(parent.frame.PortraitMask, "Show") then
            parent:SecureHook(parent.frame.PortraitMask, "Show", function(s)
                s:Hide()
            end)
        end
    end
end

function BUFPetPortrait:RefreshMask()
    local parent = BUFPet
    local maskPath = ns.db.profile.unitFrames.pet.portrait.mask

    local sPos, ePos = string.find(maskPath, "%.")
    local isTexture = sPos ~= nil
    if isTexture then
        parent.frame.PortraitMask:SetTexture(maskPath)
    else
        parent.frame.PortraitMask:SetAtlas(maskPath, false)
    end
    local width = ns.db.profile.unitFrames.pet.portrait.width
    local height = ns.db.profile.unitFrames.pet.portrait.height
    local widthScale = ns.db.profile.unitFrames.pet.portrait.maskWidthScale or 1
    local heightScale = ns.db.profile.unitFrames.pet.portrait.maskHeightScale or 1
    parent.frame.PortraitMask:SetSize(width * widthScale, height * heightScale)
end
