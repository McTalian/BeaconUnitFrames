---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.PvPIcon: BUFScaleTexture
local BUFFocusPvPIcon = {
	configPath = "unitFrames.focus.pvpIcon",
}

BUFFocusPvPIcon.optionsTable = {
	type = "group",
	handler = BUFFocusPvPIcon,
	name = ns.L["PvP Icon"],
	order = BUFFocusIndicators.optionsOrder.PVP_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Focus.PvPIcon
BUFFocusPvPIcon.dbDefaults = {
	anchorPoint = "TOP",
	relativeTo = BUFFocus.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -26,
	yOffset = -50,
	scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusPvPIcon)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.pvpIcon = BUFFocusPvPIcon.dbDefaults

ns.options.args.focus.args.indicators.args.pvpIcon = BUFFocusPvPIcon.optionsTable

function BUFFocusPvPIcon:ToggleDemoMode()
	self:_ToggleDemoMode(self.texture)
	if self.demoMode then
		local factionGroup, _ = UnitFactionGroup("focus")
		if factionGroup ~= "Horde" and factionGroup ~= "Alliance" then
			factionGroup = "FFA"
		end
		local iconSuffix = string.lower(factionGroup) .. "icon"
		self.texture:SetAtlas("ui-hud-unitframe-player-pvp-" .. iconSuffix, true)
	end
end

function BUFFocusPvPIcon:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.PvpIcon
	end
	self:RefreshScaleTextureConfig()
end

BUFFocusIndicators.PvPIcon = BUFFocusPvPIcon
