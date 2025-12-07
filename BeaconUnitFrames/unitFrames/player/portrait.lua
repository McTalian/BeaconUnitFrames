---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Portrait: BUFFramePortrait
local BUFPlayerPortrait = {
	configPath = "unitFrames.player.portrait",
	frameKey = BUFPlayer.relativeToFrames.PORTRAIT,
	module = BUFPlayer,
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
		-- TODO: maybe move this to indicators file with more options
		cornerIndicator = {
			type = "toggle",
			name = ns.L["EnableCornerIndicator"],
			desc = ns.L["EnableCornerIndicatorDesc"],
			set = "SetEnableCornerIndicator",
			get = "GetEnableCornerIndicator",
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

ns.BUFFramePortrait:ApplyMixin(BUFPlayerPortrait)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.portrait = BUFPlayerPortrait.dbDefaults

ns.options.args.player.args.portrait = BUFPlayerPortrait.optionsTable

function BUFPlayerPortrait:SetEnableCornerIndicator(info, value)
	self:DbSet("enableCornerIndicator", value)
	self:SetCornerIndicator()
end

function BUFPlayerPortrait:GetEnableCornerIndicator()
	return self:DbGet("enableCornerIndicator")
end

function BUFPlayerPortrait:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.texture = BUFPlayer.container.PlayerPortrait
		self.maskTexture = BUFPlayer.container.PlayerPortraitMask
		self.cornerIcon = BUFPlayer.contentContextual.PlayerPortraitCornerIcon
	end
	self:RefreshPortraitConfig()
	self:SetCornerIndicator()
end

function BUFPlayerPortrait:SetCornerIndicator()
	local enable = self:GetEnableCornerIndicator()
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

BUFPlayer.Portrait = BUFPlayerPortrait
