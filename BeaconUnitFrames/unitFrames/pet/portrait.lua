---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Portrait: BUFTexture, BoxMaskable
local BUFPetPortrait = {
	configPath = "unitFrames.pet.portrait",
	frameKey = BUFPet.relativeToFrames.PORTRAIT,
}

BUFPetPortrait.optionsTable = {
	type = "group",
	handler = BUFPetPortrait,
	name = ns.L["Portrait"],
	order = BUFPet.optionsOrder.PORTRAIT,
	args = {
		enabled = {
			type = "toggle",
			name = ENABLE,
			desc = ns.L["EnablePlayerPortrait"],
			set = "SetEnabled",
			get = "GetEnabled",
			order = ns.defaultOrderMap.ENABLE,
		},
	},
}

---@class BUFDbSchema.UF.Pet.Portrait
BUFPetPortrait.dbDefaults = {
	enabled = true,
	width = 37,
	height = 37,
	scale = 1,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPet.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 5,
	yOffset = -5,
	mask = "CircleMaskScalable",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

BUFPetPortrait.noAtlas = true

ns.BUFTexture:ApplyMixin(BUFPetPortrait)
ns.Mixin(BUFPetPortrait, ns.BoxMaskable)

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet
ns.dbDefaults.profile.unitFrames.pet.portrait = BUFPetPortrait.dbDefaults

ns.AddBoxMaskableOptions(BUFPetPortrait.optionsTable.args)
ns.options.args.pet.args.portrait = BUFPetPortrait.optionsTable

function BUFPetPortrait:SetEnabled(info, value)
	self:DbSet("enabled", value)
	self:ShowHidePortrait()
end

function BUFPetPortrait:GetEnabled(info)
	return self:DbGet("enabled")
end

function BUFPetPortrait:RefreshConfig()
	if not self.initialized then
		self.initialized = true
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
	local show = self:DbGet("enabled")
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
	local maskPath = self:DbGet("mask")

	local sPos, ePos = string.find(maskPath, "%.")
	local isTexture = sPos ~= nil
	if isTexture then
		parent.frame.PortraitMask:SetTexture(maskPath)
	else
		parent.frame.PortraitMask:SetAtlas(maskPath, false)
	end
	local width, height = self:GetWidth(), self:GetHeight()
	local widthScale = self:GetMaskWidthScale() or 1
	local heightScale = self:GetMaskHeightScale() or 1
	parent.frame.PortraitMask:SetSize(width * widthScale, height * heightScale)
end

BUFPet.Portrait = BUFPetPortrait
