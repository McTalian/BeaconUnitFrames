---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Health: BUFStatusBar
local BUFPlayerHealth = {
	configPath = "unitFrames.player.healthBar",
	frameKey = BUFPlayer.relativeToFrames.HEALTH,
}

BUFPlayerHealth.optionsTable = {
	type = "group",
	handler = BUFPlayerHealth,
	name = HEALTH,
	order = BUFPlayer.optionsOrder.HEALTH,
	childGroups = "tree",
	args = {},
}

---@class BUFDbSchema.UF.Player.Health
BUFPlayerHealth.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	width = 124,
	height = 20,
	xOffset = 85,
	yOffset = -40,
	frameLevel = 3,
}

ns.BUFStatusBar:ApplyMixin(BUFPlayerHealth)

BUFPlayer.Health = BUFPlayerHealth

local healthBarOrder = {}

ns.Mixin(healthBarOrder, ns.defaultOrderMap)
healthBarOrder.LEFT_TEXT = healthBarOrder.FRAME_LEVEL + 0.1
healthBarOrder.RIGHT_TEXT = healthBarOrder.LEFT_TEXT + 0.1
healthBarOrder.CENTER_TEXT = healthBarOrder.RIGHT_TEXT + 0.1
healthBarOrder.FOREGROUND = healthBarOrder.CENTER_TEXT + 0.1
healthBarOrder.BACKGROUND = healthBarOrder.FOREGROUND + 0.1

BUFPlayerHealth.topGroupOrder = healthBarOrder

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@type BUFDbSchema.UF.Player.Health
ns.dbDefaults.profile.unitFrames.player.healthBar = BUFPlayerHealth.dbDefaults

ns.options.args.player.args.healthBar = BUFPlayerHealth.optionsTable

function BUFPlayerHealth:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.barOrContainer = BUFPlayer.healthBarContainer
	end
	if not InCombatLockdown() then
		self:RefreshStatusBarConfig()
	else
		self.leftTextHandler:RefreshConfig()
		self.rightTextHandler:RefreshConfig()
		self.centerTextHandler:RefreshConfig()
		self.foregroundHandler:RefreshConfig()
		self.backgroundHandler:RefreshConfig()
	end
end

function BUFPlayerHealth:SetSize()
	self:_SetSize(self.barOrContainer)
	self:_SetSize(BUFPlayer.healthBar)

	local width, height = self:GetWidth(), self:GetHeight()
	local secureBody = format(
		[[
        self:SetWidth(%d);
        self:SetHeight(%d);
    ]],
		width,
		height
	)

	self.barOrContainer:SetAttribute("buf_restore_size", secureBody)
	BUFPlayer.healthBar:SetAttribute("buf_restore_size", secureBody)
end

function BUFPlayerHealth:SetPosition()
	self:_SetPosition(self.barOrContainer)

	---@type AnchorInfo
	local anchorInfo = self:GetPositionAnchorInfo()

	ns.BUFSecureHandler.SaveAnchor(self.barOrContainer, "PlayerHealthBarAnchor", anchorInfo)
	self.barOrContainer:SetAttribute(
		"buf_restore_position",
		[[
        self:ClearAllPoints();
        self:SetPoint(unpack(PlayerHealthBarAnchor));
    ]]
	)
end
