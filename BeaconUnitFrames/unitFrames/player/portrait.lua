---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Portrait: BUFTexture, BoxMaskable
local BUFPlayerPortrait = {
	configPath = "unitFrames.player.portrait",
	frameKey = BUFPlayer.relativeToFrames.PORTRAIT,
}

BUFPlayerPortrait.optionsOrder = {}
ns.Mixin(BUFPlayerPortrait.optionsOrder, ns.defaultOrderMap)
BUFPlayerPortrait.optionsOrder.CORNER_INDICATOR = BUFPlayerPortrait.optionsOrder.ENABLE + 0.1

BUFPlayerPortrait.optionsTable = {
	type = "group",
	handler = BUFPlayerPortrait,
	name = ns.L["Portrait"],
	order = BUFPlayer.optionsOrder.PORTRAIT,
	args = {
		enabled = {
			type = "toggle",
			name = ENABLE,
			desc = ns.L["EnablePlayerPortrait"],
			set = function(info, value)
				ns.db.profile.unitFrames.player.portrait.enabled = value
				BUFPlayerPortrait:ShowHidePortrait()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.player.portrait.enabled
			end,
			order = BUFPlayerPortrait.optionsOrder.ENABLE,
		},
		-- TODO: Move this to indicators file with more options
		cornerIndicator = {
			type = "toggle",
			name = ns.L["EnableCornerIndicator"],
			desc = ns.L["EnableCornerIndicatorDesc"],
			set = function(info, value)
				ns.db.profile.unitFrames.player.portrait.enableCornerIndicator = value
				BUFPlayerPortrait:SetCornerIndicator()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.player.portrait.enableCornerIndicator
			end,
			order = BUFPlayerPortrait.optionsOrder.CORNER_INDICATOR,
		},
	},
}

---@class BUFDbSchema.UF.Player.Portrait
BUFPlayerPortrait.dbDefaults = {
	enabled = true,
	scale = 1.0,
	width = 60,
	height = 60,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 24,
	yOffset = -19,
	enableCornerIndicator = true,
	mask = "ui-hud-unitframe-player-portrait-mask",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

BUFPlayerPortrait.noAtlas = true

ns.BUFTexture:ApplyMixin(BUFPlayerPortrait)
ns.Mixin(BUFPlayerPortrait, ns.BoxMaskable)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.portrait = BUFPlayerPortrait.dbDefaults

ns.options.args.player.args.portrait = BUFPlayerPortrait.optionsTable

function BUFPlayerPortrait:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.texture = BUFPlayer.container.PlayerPortrait
		self.maskTexture = BUFPlayer.container.PlayerPortraitMask
		self.cornerIcon = BUFPlayer.contentContextual.PlayerPortraitCornerIcon
	end
	self:ShowHidePortrait()
	self:SetPosition()
	self:SetSize()
	self:SetCornerIndicator()
end

function BUFPlayerPortrait:SetSize()
	self:_SetSize(self.texture)

	self:RefreshMask()
end

function BUFPlayerPortrait:SetPosition()
	self:_SetPosition(self.texture)

	self.maskTexture:ClearAllPoints()
	self.maskTexture:SetPoint("CENTER", self.texture, "CENTER")
end

function BUFPlayerPortrait:ShowHidePortrait()
	local show = self:DbGet("enabled")
	if show then
		BUFPlayer:Unhook(self.texture, "Show")
		BUFPlayer:Unhook(self.maskTexture, "Show")
		self.texture:Show()
		self.maskTexture:Show()
	else
		self.texture:Hide()
		self.maskTexture:Hide()
		if not BUFPlayer:IsHooked(self.texture, "Show") then
			BUFPlayer:SecureHook(self.texture, "Show", function(s)
				s:Hide()
			end)
		end
		if not BUFPlayer:IsHooked(self.maskTexture, "Show") then
			BUFPlayer:SecureHook(self.maskTexture, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFPlayerPortrait:SetCornerIndicator()
	local enable = self:DbGet("enableCornerIndicator")
	if enable then
		BUFPlayer:Unhook(self.cornerIcon, "Show")
		self.cornerIcon:Show()
	else
		self.cornerIcon:Hide()
		if not ns.BUFPlayer:IsHooked(self.cornerIcon, "Show") then
			BUFPlayer:SecureHook(self.cornerIcon, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFPlayerPortrait:RefreshMask()
	self:_RefreshMask(self.maskTexture)

	local width, height = self:GetWidth(), self:GetHeight()
	local widthScale = self:GetMaskWidthScale() or 1
	local heightScale = self:GetMaskHeightScale() or 1
	self.maskTexture:SetSize(width * widthScale, height * heightScale)
end

BUFPlayer.Portrait = BUFPlayerPortrait
