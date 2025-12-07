---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.FocusCrosshair: BUFScaleTexture
local FocusCrosshair = {
	configPath = "unitFrames.focus.focusCrosshair",
}

FocusCrosshair.optionsTable = {
	type = "group",
	handler = FocusCrosshair,
	name = ns.L["Focus Crosshair"],
	order = BUFFocusIndicators.optionsOrder.FOCUS_CROSSHAIR,
	args = {
		enabled = {
			type = "toggle",
			name = ENABLE,
			order = ns.defaultOrderMap.ENABLE,
			get = "GetEnabled",
			set = "SetEnabled",
		},
	},
}

---@class BUFDbSchema.UF.Focus.FocusCrosshair
FocusCrosshair.dbDefaults = {
	enabled = false,
	anchorPoint = "CENTER",
	relativeTo = BUFFocus.relativeToFrames.PORTRAIT,
	relativePoint = "CENTER",
	xOffset = 0,
	yOffset = 0,
	useAtlasSize = true,
	width = 128,
	height = 128,
	scale = 1,
}

ns.BUFScaleTexture:ApplyMixin(FocusCrosshair)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.focusCrosshair = FocusCrosshair.dbDefaults

ns.options.args.focus.args.indicators.args.focusCrosshair = FocusCrosshair.optionsTable

function FocusCrosshair:SetEnabled(info, value)
	self:DbSet("enabled", value)
	self:UpdateVisibility()
end

function FocusCrosshair:GetEnabled()
	return self:DbGet("enabled")
end

function FocusCrosshair:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.container:CreateTexture("BUF_FocusCrosshair", "OVERLAY")
		self.atlasTexture = "crosshair_crosshairs_128"
		self.texture:SetAtlas(self.atlasTexture, true)
	end
	self:UpdateVisibility()
	self:RefreshScaleTextureConfig()
end

function FocusCrosshair:UpdateVisibility()
	if self:GetEnabled() then
		self.texture:Show()
	else
		self.texture:Hide()
	end
end

BUFFocusIndicators.FocusCrosshair = FocusCrosshair
