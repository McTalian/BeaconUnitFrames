---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Frame: Sizable, BackgroundTexturable
local BUFPlayerFrame = {
	configPath = "unitFrames.player.frame",
}

ns.Mixin(BUFPlayerFrame, ns.Sizable, ns.BackgroundTexturable)

BUFPlayer.Frame = BUFPlayerFrame

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.Frame
ns.dbDefaults.profile.unitFrames.player.frame = {
	width = 232,
	height = 100,
	enableFrameFlash = true,
	enableFrameTexture = true,
	enableStatusTexture = true,
	useBackgroundTexture = false,
	backgroundTexture = "None",
}

local frameOrder = {}
ns.Mixin(frameOrder, ns.defaultOrderMap)
frameOrder.FRAME_FLASH = frameOrder.ENABLE + 0.1
frameOrder.FRAME_TEXTURE = frameOrder.FRAME_FLASH + 0.1
frameOrder.STATUS_TEXTURE = frameOrder.FRAME_TEXTURE + 0.1

local frame = {
	type = "group",
	handler = BUFPlayerFrame,
	name = ns.L["Frame"],
	order = BUFPlayer.optionsOrder.FRAME,
	args = {
		frameFlash = {
			type = "toggle",
			name = ns.L["EnableFrameFlash"],
			set = function(info, value)
				ns.db.profile.unitFrames.player.frame.enableFrameFlash = value
				BUFPlayerFrame:SetFrameFlash()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.player.frame.enableFrameFlash
			end,
			order = frameOrder.FRAME_FLASH,
		},
		frameTexture = {
			type = "toggle",
			name = ns.L["EnableFrameTexture"],
			set = function(info, value)
				ns.db.profile.unitFrames.player.frame.enableFrameTexture = value
				BUFPlayerFrame:SetFrameTexture()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.player.frame.enableFrameTexture
			end,
			order = frameOrder.FRAME_TEXTURE,
		},
		statusTexture = {
			type = "toggle",
			name = ns.L["EnableStatusTexture"],
			set = function(info, value)
				ns.db.profile.unitFrames.player.frame.enableStatusTexture = value
				BUFPlayerFrame:SetStatusTexture()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.player.frame.enableStatusTexture
			end,
			order = frameOrder.STATUS_TEXTURE,
		},
	},
}

ns.AddBackgroundTextureOptions(frame.args, frameOrder)
ns.AddSizableOptions(frame.args, frameOrder)

ns.options.args.player.args.frame = frame

function BUFPlayerFrame:RefreshConfig()
	self:SetSize()
	self:SetFrameFlash()
	self:SetFrameTexture()
	self:SetStatusTexture()
	self:RefreshBackgroundTexture()

	if not self.initialized then
		self.initialized = true

		local player = BUFPlayer

		if not player:IsHooked(player.container.FrameTexture, "SetShown") then
			player:SecureHook(player.container.FrameTexture, "SetShown", function(s, shown)
				if not ns.db.profile.unitFrames.player.frame.enableFrameTexture then
					s:Hide()
				end
			end)
		end

		if not player:IsHooked(player.frame, "AnchorSelectionFrame") then
			player:SecureHook(player.frame, "AnchorSelectionFrame", function()
				if player.frame.Selection then
					player.frame.Selection:ClearAllPoints()
					player.frame.Selection:SetAllPoints(player.frame)
				end
			end)
		end
	end
end

function BUFPlayerFrame:SetSize()
	local player = BUFPlayer
	local width = ns.db.profile.unitFrames.player.frame.width
	local height = ns.db.profile.unitFrames.player.frame.height
	player.frame:SetWidth(width)
	player.frame:SetHeight(height)
	player.frame:SetHitRectInsets(0, 0, 0, 0)
end

function BUFPlayerFrame:SetFrameFlash()
	local player = BUFPlayer
	local enable = ns.db.profile.unitFrames.player.frame.enableFrameFlash
	if enable then
		player:Unhook(player.container.FrameFlash, "Show")
	else
		player.container.FrameFlash:Hide()
		if not ns.BUFPlayer:IsHooked(player.container.FrameFlash, "Show") then
			player:SecureHook(player.container.FrameFlash, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFPlayerFrame:SetFrameTexture()
	local enable = ns.db.profile.unitFrames.player.frame.enableFrameTexture
	local texture = BUFPlayer.container.FrameTexture
	local vehicleTexture = BUFPlayer.container.VehicleFrameTexture
	local healthBarMask = BUFPlayer.healthBarContainer.HealthBarMask
	local manaBarMask = BUFPlayer.manaBar.ManaBarMask

	if enable then
		BUFPlayer:Unhook(texture, "Show")
		BUFPlayer:Unhook(vehicleTexture, "Show")
		BUFPlayer:Unhook(healthBarMask, "Show")
		BUFPlayer:Unhook(manaBarMask, "Show")
		if UnitInVehicle("player") then
			vehicleTexture:Show()
		else
			texture:Show()
		end
		healthBarMask:Show()
		manaBarMask:Show()
	else
		texture:Hide()
		vehicleTexture:Hide()
		healthBarMask:Hide()
		manaBarMask:Hide()

		local function HideOnShow(s)
			s:Hide()
		end

		if not BUFPlayer:IsHooked(texture, "Show") then
			BUFPlayer:SecureHook(texture, "Show", HideOnShow)
		end

		if not BUFPlayer:IsHooked(vehicleTexture, "Show") then
			BUFPlayer:SecureHook(vehicleTexture, "Show", HideOnShow)
		end

		if not BUFPlayer:IsHooked(healthBarMask, "Show") then
			BUFPlayer:SecureHook(healthBarMask, "Show", HideOnShow)
		end

		if not BUFPlayer:IsHooked(manaBarMask, "Show") then
			BUFPlayer:SecureHook(manaBarMask, "Show", HideOnShow)
		end

		if not BUFPlayer:IsHooked(manaBarMask, "SetShown") then
			BUFPlayer:SecureHook(manaBarMask, "SetShown", HideOnShow)
		end
	end
end

function BUFPlayerFrame:SetStatusTexture()
	local player = BUFPlayer
	local enable = ns.db.profile.unitFrames.player.frame.enableStatusTexture
	if enable then
		player:Unhook(player.contentMain.StatusTexture, "Show")
	else
		player.contentMain.StatusTexture:Hide()
		if not ns.BUFPlayer:IsHooked(player.contentMain.StatusTexture, "Show") then
			player:SecureHook(player.contentMain.StatusTexture, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFPlayerFrame:RefreshBackgroundTexture()
	local useBackgroundTexture = ns.db.profile.unitFrames.player.frame.useBackgroundTexture
	if not useBackgroundTexture then
		if self.backdropFrame then
			self.backdropFrame:Hide()
		end
		return
	end

	if self.backdropFrame == nil then
		self.backdropFrame = CreateFrame("Frame", nil, ns.BUFPlayer.frame, "BackdropTemplate")
	end

	local backgroundTexture = ns.db.profile.unitFrames.player.frame.backgroundTexture
	local bgTexturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, backgroundTexture)
	if not bgTexturePath then
		bgTexturePath = "Interface/None"
	end

	self.backdropFrame:ClearAllPoints()
	self.backdropFrame:SetAllPoints(ns.BUFPlayer.frame)

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
