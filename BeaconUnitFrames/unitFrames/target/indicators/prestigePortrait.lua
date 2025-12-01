---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.PrestigePortrait: BUFScaleTexture
local BUFTargetPrestigePortrait = {
	configPath = "unitFrames.target.prestigePortrait",
}

BUFTargetPrestigePortrait.optionsTable = {
	type = "group",
	handler = BUFTargetPrestigePortrait,
	name = ns.L["Prestige Portrait"],
	order = BUFTargetIndicators.optionsOrder.PRESTIGE_PORTRAIT,
	args = {},
}

---@class BUFDbSchema.UF.Target.PrestigePortrait
BUFTargetPrestigePortrait.dbDefaults = {
	scale = 1.0,
	anchorPoint = "TOPRIGHT",
	relativeTo = ns.DEFAULT,
	relativePoint = "TOPRIGHT",
	xOffset = -2,
	yOffset = -38,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetPrestigePortrait)

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.prestigePortrait = BUFTargetPrestigePortrait.dbDefaults

ns.options.args.target.args.indicators.args.prestigePortrait = BUFTargetPrestigePortrait.optionsTable

function BUFTargetPrestigePortrait:ToggleDemoMode()
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

function BUFTargetPrestigePortrait:RefreshConfig()
	if not self.initialized then
		self.initialized = true
		self.defaultRelativeTo = BUFTarget.contentContextual
		self.texture = BUFTarget.contentContextual.PrestigePortrait
		self.secondaryTexture = BUFTarget.contentContextual.PrestigeBadge
	end
	self:RefreshScaleTextureConfig()
end

function BUFTargetPrestigePortrait:SetScaleFactor()
	self:_SetScaleFactor(self.texture)
	self:_SetScaleFactor(self.secondaryTexture)
end

BUFTargetIndicators.PrestigePortrait = BUFTargetPrestigePortrait
