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
			set = function(info, value)
				ns.db.profile.unitFrames.pet.frame.enableFrameFlash = value
				BUFPetFrame:SetFrameFlash()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.pet.frame.enableFrameFlash
			end,
			order = frameOrder.FRAME_FLASH,
		},
		frameTexture = {
			type = "toggle",
			name = ns.L["EnableFrameTexture"],
			set = function(info, value)
				ns.db.profile.unitFrames.pet.frame.enableFrameTexture = value
				BUFPetFrame:SetFrameTexture()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.pet.frame.enableFrameTexture
			end,
			order = frameOrder.FRAME_TEXTURE,
		},
		statusTexture = {
			type = "toggle",
			name = ns.L["EnableStatusTexture"],
			set = function(info, value)
				ns.db.profile.unitFrames.pet.frame.enableStatusTexture = value
				BUFPetFrame:SetStatusTexture()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.pet.frame.enableStatusTexture
			end,
			order = frameOrder.STATUS_TEXTURE,
		},
	},
}

ns.AddBackgroundTextureOptions(frame.args, frameOrder)
ns.AddSizableOptions(frame.args, frameOrder)

ns.options.args.pet.args.frame = frame

function BUFPetFrame:RefreshConfig()
	self:SetSize()
	self:SetFrameFlash()
	self:SetFrameTexture()
	self:SetStatusTexture()
	self:RefreshBackgroundTexture()

	if not self.initialized then
		BUFPet.FrameInit(self)

		if not BUFPet:IsHooked(BUFPet.frame, "AnchorSelectionFrame") then
			BUFPet:SecureHook(BUFPet.frame, "AnchorSelectionFrame", function()
				if BUFPet.frame.Selection then
					BUFPet.frame.Selection:ClearAllPoints()
					BUFPet.frame.Selection:SetAllPoints(BUFPet.frame)
				end
			end)
		end
	end
end

function BUFPetFrame:SetSize()
	local pet = BUFPet
	local width = ns.db.profile.unitFrames.pet.frame.width
	local height = ns.db.profile.unitFrames.pet.frame.height
	pet.frame:SetWidth(width)
	pet.frame:SetHeight(height)
	pet.frame:SetHitRectInsets(0, 0, 0, 0)
end

function BUFPetFrame:SetFrameFlash()
	local pet = BUFPet
	local enable = ns.db.profile.unitFrames.pet.frame.enableFrameFlash
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
	local enable = ns.db.profile.unitFrames.pet.frame.enableFrameTexture
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
	local enable = ns.db.profile.unitFrames.pet.frame.enableStatusTexture
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
	local useBackgroundTexture = ns.db.profile.unitFrames.pet.frame.useBackgroundTexture
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

	local backgroundTexture = ns.db.profile.unitFrames.pet.frame.backgroundTexture
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
