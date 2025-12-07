---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Frame: Sizable, BackgroundTexturable
local BUFPetFrame = {
	configPath = "unitFrames.pet.frame",
	frameKey = BUFPet.relativeToFrames.FRAME,
}

ns.Mixin(BUFPetFrame, ns.Sizable, ns.BackgroundTexturable)

BUFPet.Frame = BUFPetFrame

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

---@class BUFDbSchema.UF.Pet.Frame
ns.dbDefaults.profile.unitFrames.pet.frame = {
	width = 120,
	height = 49,
	enableFrameFlash = true,
	enableFrameTexture = true,
	enableStatusTexture = true,
	enableHitIndicator = true,
	useBackgroundTexture = false,
	backgroundTexture = "None",
}

local frameOrder = {}
ns.Mixin(frameOrder, ns.defaultOrderMap)
frameOrder.FRAME_FLASH = frameOrder.ENABLE + 0.1
frameOrder.FRAME_TEXTURE = frameOrder.FRAME_FLASH + 0.1
frameOrder.STATUS_TEXTURE = frameOrder.FRAME_TEXTURE + 0.1
frameOrder.HIT_INDICATOR = frameOrder.STATUS_TEXTURE + 0.1

local frame = {
	type = "group",
	handler = BUFPetFrame,
	name = ns.L["Frame"],
	order = BUFPet.optionsOrder.FRAME,
	args = {
		frameFlash = {
			type = "toggle",
			name = ns.L["EnableFrameFlash"],
			set = "SetEnableFrameFlash",
			get = "GetEnableFrameFlash",
			order = frameOrder.FRAME_FLASH,
		},
		frameTexture = {
			type = "toggle",
			name = ns.L["EnableFrameTexture"],
			set = "SetEnableFrameTexture",
			get = "GetEnableFrameTexture",
			order = frameOrder.FRAME_TEXTURE,
		},
		statusTexture = {
			type = "toggle",
			name = ns.L["EnableStatusTexture"],
			set = "SetEnableStatusTexture",
			get = "GetEnableStatusTexture",
			order = frameOrder.STATUS_TEXTURE,
		},
	},
}

ns.AddBackgroundTextureOptions(frame.args, frameOrder)
ns.AddSizableOptions(frame.args, frameOrder)

ns.options.args.pet.args.frame = frame

function BUFPetFrame:SetEnableFrameFlash(info, value)
	self:DbSet("enableFrameFlash", value)
	BUFPetFrame:SetFrameFlash()
end

function BUFPetFrame:GetEnableFrameFlash(info)
	return self:DbGet("enableFrameFlash")
end

function BUFPetFrame:SetEnableFrameTexture(info, value)
	self:DbSet("enableFrameTexture", value)
	BUFPetFrame:SetFrameTexture()
end

function BUFPetFrame:GetEnableFrameTexture(info)
	return self:DbGet("enableFrameTexture")
end

function BUFPetFrame:SetEnableStatusTexture(info, value)
	self:DbSet("enableStatusTexture", value)
	BUFPetFrame:SetStatusTexture()
end

function BUFPetFrame:GetEnableStatusTexture(info)
	return self:DbGet("enableStatusTexture")
end

function BUFPetFrame:RefreshConfig()
	if not self.initialized then
		BUFPet.FrameInit(self)

		self.frame = BUFPet.frame

		if not BUFPet:IsHooked(BUFPet.frame, "AnchorSelectionFrame") then
			BUFPet:SecureHook(BUFPet.frame, "AnchorSelectionFrame", function()
				if BUFPet.frame.Selection then
					BUFPet.frame.Selection:ClearAllPoints()
					BUFPet.frame.Selection:SetAllPoints(BUFPet.frame)
				end
			end)
		end
	end
	self:SetSize()
	self:SetFrameFlash()
	self:SetFrameTexture()
	self:SetStatusTexture()
	self:RefreshBackgroundTexture()
end

function BUFPetFrame:SetSize()
	self:_SetSize(self.frame)
	self.frame:SetHitRectInsets(0, 0, 0, 0)
end

function BUFPetFrame:SetFrameFlash()
	local pet = BUFPet
	local enable = self:DbGet("enableFrameFlash")
	if enable then
		pet:Unhook(PetFrameFlash, "Show")
	else
		PetFrameFlash:Hide()
		if not ns.BUFPet:IsHooked(PetFrameFlash, "Show") then
			pet:SecureHook(PetFrameFlash, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFPetFrame:SetFrameTexture()
	local pet = BUFPet
	local texture = PetFrameTexture
	local healthBarMask = PetFrameHealthBarMask
	local manaBarMask = PetFrameManaBarMask
	local enable = self:DbGet("enableFrameTexture")
	if enable then
		pet:Unhook(texture, "Show")
		pet:Unhook(healthBarMask, "Show")
		pet:Unhook(manaBarMask, "Show")
		texture:Show()
		healthBarMask:Show()
		manaBarMask:Show()
	else
		texture:Hide()
		healthBarMask:Hide()
		manaBarMask:Hide()

		local function HideOnShow(s)
			s:Hide()
		end

		if not ns.BUFPet:IsHooked(texture, "Show") then
			pet:SecureHook(texture, "Show", HideOnShow)
		end

		if not ns.BUFPet:IsHooked(healthBarMask, "Show") then
			pet:SecureHook(healthBarMask, "Show", HideOnShow)
		end

		if not ns.BUFPet:IsHooked(manaBarMask, "Show") then
			pet:SecureHook(manaBarMask, "Show", HideOnShow)
		end

		if not BUFPet:IsHooked(manaBarMask, "SetShown") then
			pet:SecureHook(manaBarMask, "SetShown", HideOnShow)
		end
	end
end

function BUFPetFrame:SetStatusTexture()
	local pet = BUFPet
	local enable = self:DbGet("enableStatusTexture")
	if enable then
		pet:Unhook(PetAttackModeTexture, "Show")
	else
		PetAttackModeTexture:Hide()
		if not ns.BUFPet:IsHooked(PetAttackModeTexture, "Show") then
			pet:SecureHook(PetAttackModeTexture, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFPetFrame:RefreshBackgroundTexture()
	local useBackgroundTexture = self:DbGet("useBackgroundTexture")
	if not useBackgroundTexture then
		if self.backdropFrame then
			self.backdropFrame:Hide()
		end
		return
	end

	if self.backdropFrame == nil then
		self.backdropFrame = CreateFrame("Frame", nil, ns.BUFPet.frame, "BackdropTemplate")
		self.backdropFrame:SetFrameStrata("BACKGROUND")
	end

	local backgroundTexture = self:DbGet("backgroundTexture")
	local bgTexturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, backgroundTexture)
	if not bgTexturePath then
		bgTexturePath = "Interface/None"
	end

	self.backdropFrame:ClearAllPoints()
	self.backdropFrame:SetAllPoints(ns.BUFPet.frame)

	self.backdropFrame:SetBackdrop({
		bgFile = bgTexturePath,
		edgeFile = nil,
		tile = true,
		tileSize = 16,
		edgeSize = 0,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	self.backdropFrame:Show()
end
