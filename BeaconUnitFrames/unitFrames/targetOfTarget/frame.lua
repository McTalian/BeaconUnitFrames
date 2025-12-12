---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Frame: Sizable, BackgroundTexturable
local BUFToTFrame = {
	configPath = "unitFrames.tot.frame",
	frameKey = BUFToT.relativeToFrames.FRAME,
}

ns.Mixin(BUFToTFrame, ns.Sizable, ns.BackgroundTexturable)

BUFToT.Frame = BUFToTFrame

---@class BUFDbSchema.UF.ToT
ns.dbDefaults.profile.unitFrames.tot = ns.dbDefaults.profile.unitFrames.tot

---@class BUFDbSchema.UF.ToT.Frame
ns.dbDefaults.profile.unitFrames.tot.frame = {
	width = 120,
	height = 49,
	enableFrameTexture = true,
	useBackgroundTexture = false,
	backgroundTexture = "None",
}

local frameOrder = {}

ns.Mixin(frameOrder, ns.defaultOrderMap)
frameOrder.FRAME_FLASH = frameOrder.ENABLE + 0.1
frameOrder.FRAME_TEXTURE = frameOrder.FRAME_FLASH + 0.1
frameOrder.BACKDROP_AND_BORDER = frameOrder.FRAME_TEXTURE + 0.1

local frame = {
	type = "group",
	handler = BUFToTFrame,
	name = ns.L["Frame"],
	order = BUFToT.optionsOrder.FRAME,
	args = {
		frameTexture = {
			type = "toggle",
			name = ns.L["EnableFrameTexture"],
			set = "SetEnableFrameTexture",
			get = "GetEnableFrameTexture",
			order = frameOrder.FRAME_TEXTURE,
		},
	},
}

ns.AddSizableOptions(frame.args, frameOrder)
ns.AddBackgroundTextureOptions(frame.args, frameOrder)

ns.options.args.tot.args.frame = frame

function BUFToTFrame:SetEnableFrameTexture(info, value)
	self:DbSet("enableFrameTexture", value)
	self:SetFrameTexture()
end

function BUFToTFrame:GetEnableFrameTexture(info)
	return self:DbGet("enableFrameTexture")
end

function BUFToTFrame:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)
	end
	if not self.frame then
		self.frame = BUFToT.frame

		if self.frame then
			if not BUFToT:IsHooked(BUFToT.frame, "AnchorSelectionFrame") then
				BUFToT:SecureHook(BUFToT.frame, "AnchorSelectionFrame", function()
					if BUFToT.frame.Selection then
						BUFToT.frame.Selection:ClearAllPoints()
						BUFToT.frame.Selection:SetAllPoints(BUFToT.frame)
					end
				end)
			end
		end
	end
	self:SetSize()
	self:SetFrameTexture()
	self:RefreshBackgroundTexture()
end

function BUFToTFrame:SetSize()
	self:_SetSize(self.frame)
end

function BUFToTFrame:SetFrameTexture()
	local enable = self:DbGet("enableFrameTexture")
	local texture = BUFToT.frame.FrameTexture
	local healthBarMask = BUFToT.healthBar.HealthBarMask
	local manaBarMask = BUFToT.manaBar.ManaBarMask
	if enable then
		BUFToT:Unhook(texture, "Show")
		BUFToT:Unhook(healthBarMask, "Show")
		BUFToT:Unhook(manaBarMask, "Show")
		texture:Show()
		healthBarMask:Show()
		manaBarMask:Show()
	else
		texture:Hide()
		healthBarMask:Hide()
		manaBarMask:Hide()

		if not BUFToT:IsHooked(texture, "Show") then
			BUFToT:SecureHook(texture, "Show", function(s)
				s:Hide()
			end)
		end

		if not BUFToT:IsHooked(healthBarMask, "Show") then
			BUFToT:SecureHook(healthBarMask, "Show", function(s)
				s:Hide()
			end)
		end

		if not BUFToT:IsHooked(manaBarMask, "Show") then
			BUFToT:SecureHook(manaBarMask, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFToTFrame:RefreshBackgroundTexture()
	local useBackgroundTexture = self:DbGet("useBackgroundTexture")
	if not useBackgroundTexture then
		if self.backdropFrame then
			self.backdropFrame:Hide()
		end
		return
	end

	if not self.backdropFrame then
		self.backdropFrame = CreateFrame("Frame", nil, BUFToT.frame, "BackdropTemplate")
		self.backdropFrame:SetFrameStrata("BACKGROUND")
	end

	local backgroundTexture = self:DbGet("backgroundTexture")
	local bgTexturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, backgroundTexture)
	if not bgTexturePath then
		bgTexturePath = "Interface/None"
	end

	self.backdropFrame:ClearAllPoints()
	self.backdropFrame:SetAllPoints(BUFToT.frame)

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
