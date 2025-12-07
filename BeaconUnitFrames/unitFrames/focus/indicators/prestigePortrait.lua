---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Indicators
local BUFFocusIndicators = ns.BUFFocus.Indicators

---@class BUFFocus.Indicators.PrestigePortrait: BUFScaleTexture
local BUFFocusPrestigePortrait = {
	configPath = "unitFrames.focus.prestigePortrait",
}

BUFFocusPrestigePortrait.optionsTable = {
	type = "group",
	handler = BUFFocusPrestigePortrait,
	name = ns.L["Prestige Portrait"],
	order = BUFFocusIndicators.optionsOrder.PRESTIGE_PORTRAIT,
	args = {},
}

---@class BUFDbSchema.UF.Focus.PrestigePortrait
BUFFocusPrestigePortrait.dbDefaults = {
	scale = 1.0,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFFocus.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -2,
	yOffset = -38,
}

ns.BUFScaleTexture:ApplyMixin(BUFFocusPrestigePortrait)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.prestigePortrait = BUFFocusPrestigePortrait.dbDefaults

ns.options.args.focus.args.indicators.args.prestigePortrait = BUFFocusPrestigePortrait.optionsTable

function BUFFocusPrestigePortrait:ToggleDemoMode()
	if self.demoMode then
		self.demoMode = false
		self.texture:Hide()
		self.secondaryTexture:Hide()
	else
		self.demoMode = true
		self.texture:SetAtlas("honorsystem-portrait-neutral", false)
		self.texture:Show()
		self.secondaryTexture:SetTexture("interface/pvpframe/icons/prestige-icon-1.blp")
		self.secondaryTexture:Show()
	end
end

function BUFFocusPrestigePortrait:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.contentContextual.PrestigePortrait
		self.secondaryTexture = BUFFocus.contentContextual.PrestigeBadge
	end
	self:RefreshScaleTextureConfig()
end

function BUFFocusPrestigePortrait:SetScaleFactor()
	self:_SetScaleFactor(self.texture)
	self:_SetScaleFactor(self.secondaryTexture)
end

BUFFocusIndicators.PrestigePortrait = BUFFocusPrestigePortrait
