---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Frame: Sizable, BackgroundTexturable
local BUFToFocusFrame = {
	configPath = "unitFrames.tofocus.frame",
	frameKey = BUFToFocus.relativeToFrames.FRAME,
}

ns.Mixin(BUFToFocusFrame, ns.Sizable, ns.BackgroundTexturable)

BUFToFocus.Frame = BUFToFocusFrame

---@class BUFDbSchema.UF.ToFocus
ns.dbDefaults.profile.unitFrames.tofocus = ns.dbDefaults.profile.unitFrames.tofocus

---@class BUFDbSchema.UF.ToFocus.Frame
ns.dbDefaults.profile.unitFrames.tofocus.frame = {
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
	handler = BUFToFocusFrame,
	name = ns.L["Frame"],
	order = BUFToFocus.optionsOrder.FRAME,
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

ns.options.args.tofocus.args.frame = frame

function BUFToFocusFrame:SetEnableFrameTexture(info, value)
	self:DbSet("enableFrameTexture", value)
	self:SetFrameTexture()
end

function BUFToFocusFrame:GetEnableFrameTexture(info)
	return self:DbGet("enableFrameTexture")
end

function BUFToFocusFrame:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.frame = BUFToFocus.frame

		if not BUFToFocus:IsHooked(BUFToFocus.frame, "AnchorSelectionFrame") then
			BUFToFocus:SecureHook(BUFToFocus.frame, "AnchorSelectionFrame", function()
				if BUFToFocus.frame.Selection then
					BUFToFocus.frame.Selection:ClearAllPoints()
					BUFToFocus.frame.Selection:SetAllPoints(BUFToFocus.frame)
				end
			end)
		end
	end
	self:SetSize()
	self:SetFrameTexture()
	self:RefreshBackgroundTexture()
end

function BUFToFocusFrame:SetSize()
	self:_SetSize(self.frame)
end

function BUFToFocusFrame:SetFrameTexture()
	local enable = self:DbGet("enableFrameTexture")
	local texture = BUFToFocus.frame.FrameTexture
	local healthBarMask = BUFToFocus.healthBar.HealthBarMask
	local manaBarMask = BUFToFocus.manaBar.ManaBarMask
	if enable then
		BUFToFocus:Unhook(texture, "Show")
		BUFToFocus:Unhook(healthBarMask, "Show")
		BUFToFocus:Unhook(manaBarMask, "Show")
		texture:Show()
		healthBarMask:Show()
		manaBarMask:Show()
	else
		texture:Hide()
		healthBarMask:Hide()
		manaBarMask:Hide()

		if not BUFToFocus:IsHooked(texture, "Show") then
			BUFToFocus:SecureHook(texture, "Show", function(s)
				s:Hide()
			end)
		end

		if not BUFToFocus:IsHooked(healthBarMask, "Show") then
			BUFToFocus:SecureHook(healthBarMask, "Show", function(s)
				s:Hide()
			end)
		end

		if not BUFToFocus:IsHooked(manaBarMask, "Show") then
			BUFToFocus:SecureHook(manaBarMask, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFToFocusFrame:RefreshBackgroundTexture()
	local useBackgroundTexture = self:DbGet("useBackgroundTexture")
	if not useBackgroundTexture then
		if self.backdropFrame then
			self.backdropFrame:Hide()
		end
		return
	end

	if not self.backdropFrame then
		self.backdropFrame = CreateFrame("Frame", nil, BUFToFocus.frame, "BackdropTemplate")
		self.backdropFrame:SetFrameStrata("BACKGROUND")
	end

	local backgroundTexture = self:DbGet("backgroundTexture")
	local bgTexturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, backgroundTexture)
	if not bgTexturePath then
		bgTexturePath = "Interface/None"
	end

	self.backdropFrame:ClearAllPoints()
	self.backdropFrame:SetAllPoints(BUFToFocus.frame)

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
