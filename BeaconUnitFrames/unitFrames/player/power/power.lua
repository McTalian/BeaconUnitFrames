---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Power: BUFStatusBar
local BUFPlayerPower = {
	configPath = "unitFrames.player.powerBar",
	frameKey = BUFPlayer.relativeToFrames.POWER,
}

BUFPlayerPower.optionsTable = {
	type = "group",
	handler = BUFPlayerPower,
	name = POWER_TYPE_POWER,
	order = BUFPlayer.optionsOrder.POWER,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.Player.Power
BUFPlayerPower.dbDefaults = {
	width = 124,
	height = 10,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 85,
	yOffset = -61,
	frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFPlayerPower)

BUFPlayer.Power = BUFPlayerPower

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

ns.dbDefaults.profile.unitFrames.player.powerBar = BUFPlayerPower.dbDefaults

local powerBarOrder = {}

ns.Mixin(powerBarOrder, ns.defaultOrderMap)
powerBarOrder.LEFT_TEXT = powerBarOrder.FRAME_LEVEL + 0.1
powerBarOrder.RIGHT_TEXT = powerBarOrder.LEFT_TEXT + 0.1
powerBarOrder.CENTER_TEXT = powerBarOrder.RIGHT_TEXT + 0.1
powerBarOrder.FOREGROUND = powerBarOrder.CENTER_TEXT + 0.1
powerBarOrder.BACKGROUND = powerBarOrder.FOREGROUND + 0.1

BUFPlayerPower.topGroupOrder = powerBarOrder

ns.options.args.player.args.powerBar = BUFPlayerPower.optionsTable

function BUFPlayerPower:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.barOrContainer = BUFPlayer.manaBar
	end
	self:RefreshStatusBarConfig()
end

function BUFPlayerPower:SetUnprotectedSize()
	local manaBar = BUFPlayer.manaBar
	self:_SetSize(manaBar.FullPowerFrame)
	self:_SetSize(manaBar.FullPowerFrame.SpikeFrame)
	self:_SetSize(manaBar.FullPowerFrame.PulseFrame)
end

function BUFPlayerPower:SetSize()
	self:_SetSize(self.barOrContainer)
	self:SetUnprotectedSize()

	local width, height = self:GetWidth(), self:GetHeight()

	BUFPlayer.manaBar:SetAttribute(
		"buf_restore_size",
		format(
			[[
        local width, height = %d, %d;
        self:SetWidth(width);
        self:SetHeight(height);
    ]],
			width,
			height
		)
	)
end

function BUFPlayerPower:SetPosition()
	self:_SetPosition(self.barOrContainer)

	local anchorInfo = self:GetPositionAnchorInfo()

	ns.BUFSecureHandler.SaveAnchor(self.barOrContainer, "PlayerManaBarAnchor", anchorInfo)
	self.barOrContainer:SetAttribute(
		"buf_restore_position",
		[[
        self:ClearAllPoints();
        self:SetPoint(unpack(PlayerManaBarAnchor));
    ]]
	)
end
