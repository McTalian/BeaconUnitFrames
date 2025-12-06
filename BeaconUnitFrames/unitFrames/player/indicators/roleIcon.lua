---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.RoleIcon: BUFScaleTexture
local BUFPlayerRoleIcon = {
	configPath = "unitFrames.player.roleIcon",
}

BUFPlayerRoleIcon.optionsTable = {
	type = "group",
	handler = BUFPlayerRoleIcon,
	name = ns.L["Role Icon"],
	order = BUFPlayerIndicators.optionsOrder.ROLE_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Player.RoleIcon
BUFPlayerRoleIcon.dbDefaults = {
	scale = 1.0,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 196,
	yOffset = -27,
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerRoleIcon)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.roleIcon = BUFPlayerRoleIcon.dbDefaults

ns.options.args.player.args.indicators.args.roleIcon = BUFPlayerRoleIcon.optionsTable

function BUFPlayerRoleIcon:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.customRelativeToOptions = BUFPlayer.customRelativeToOptions
		self.customRelativeToSorting = BUFPlayer.customRelativeToSorting

		self.texture = BUFPlayer.contentContextual.RoleIcon
	end
	self:RefreshScaleTextureConfig()
end

BUFPlayerIndicators.RoleIcon = BUFPlayerRoleIcon
