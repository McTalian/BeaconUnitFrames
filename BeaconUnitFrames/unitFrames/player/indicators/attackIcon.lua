---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.AttackIcon: BUFScaleTexture
local BUFPlayerAttackIcon = {
	configPath = "unitFrames.player.attackIcon",
}

BUFPlayerAttackIcon.optionsTable = {
	type = "group",
	handler = BUFPlayerAttackIcon,
	name = ns.L["Attack Icon"],
	order = BUFPlayerIndicators.optionsOrder.ATTACK_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Player.AttackIcon
BUFPlayerAttackIcon.dbDefaults = {
	scale = 1.0,
	anchorPoint = "TOPLEFT",
	relativeTo = ns.DEFAULT,
	relativePoint = "TOPLEFT",
	xOffset = 64,
	yOffset = -62,
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerAttackIcon)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.attackIcon = BUFPlayerAttackIcon.dbDefaults

ns.options.args.player.args.indicators.args.attackIcon = BUFPlayerAttackIcon.optionsTable

function BUFPlayerAttackIcon:RefreshConfig()
	if not self.texture then
		self.texture = BUFPlayer.contentContextual.AttackIcon
		self.defaultRelativeTo = BUFPlayer.contentContextual
	end
	self:RefreshScaleTextureConfig()
end

BUFPlayerIndicators.AttackIcon = BUFPlayerAttackIcon
