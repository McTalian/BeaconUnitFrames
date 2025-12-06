---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.GroupIndicator: Positionable, Fontable, BackgroundTexturable, Colorable, Demoable
local BUFPlayerGroupIndicator = {
	configPath = "unitFrames.player.groupIndicator",
}

ns.Mixin(BUFPlayerGroupIndicator, ns.Positionable, ns.Fontable, ns.BackgroundTexturable, ns.Colorable, ns.Demoable)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.GroupIndicator
ns.dbDefaults.profile.unitFrames.player.groupIndicator = {
	anchorPoint = "BOTTOMRIGHT",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 210,
	yOffset = -29,
	useFontObjects = true,
	fontObject = "GameFontNormalSmall",
	fontColor = { 1, 1, 1, 1 },
	fontFace = "Friz Quadrata TT",
	fontSize = 12,
	fontFlags = {
		[ns.FontFlags.OUTLINE] = false,
		[ns.FontFlags.THICKOUTLINE] = false,
		[ns.FontFlags.MONOCHROME] = false,
	},
	fontShadowColor = { 0, 0, 0, 1 },
	fontShadowOffsetX = 1,
	fontShadowOffsetY = -1,
	useBackgroundTexture = false,
	backgroundTexture = "None",
	useCustomColor = false,
	customColor = { 0, 0, 0, 0.5 },
}

local groupIndicator = {
	type = "group",
	handler = BUFPlayerGroupIndicator,
	name = ns.L["GroupIndicator"],
	order = BUFPlayerIndicators.optionsOrder.GROUP_INDICATOR,
	args = {},
}

ns.AddPositionableOptions(groupIndicator.args)
ns.AddFontOptions(groupIndicator.args)
ns.AddBackgroundTextureOptions(groupIndicator.args)
ns.AddColorOptions(groupIndicator.args)
ns.AddDemoOptions(groupIndicator.args)

ns.options.args.player.args.indicators.args.groupIndicator = groupIndicator

function BUFPlayerGroupIndicator:ToggleDemoMode()
	local grpInd = BUFPlayer.contentContextual.GroupIndicator
	self:_ToggleDemoMode(grpInd)
	if self.demoMode then
		self.fontString:SetText(GROUP .. " " .. 1)
		grpInd:SetWidth(self.fontString:GetWidth() + 40)
	end
end

function BUFPlayerGroupIndicator:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.fontString = PlayerFrameGroupIndicatorText
	end
	self:SetPosition()
	self:SetFont()
	self:SetFontShadow()
	self:RefreshBackgroundTexture()
end

function BUFPlayerGroupIndicator:SetPosition()
	self:_SetPosition(self.fontString)
end

function BUFPlayerGroupIndicator:RefreshBackgroundTexture()
	local grpInd = BUFPlayer.contentContextual.GroupIndicator
	local useBackgroundTexture = ns.db.profile.unitFrames.player.groupIndicator.useBackgroundTexture

	local show
	local regions = { grpInd:GetRegions() }
	if not useBackgroundTexture then
		show = grpInd:IsShown()
	else
		show = false
	end
	for i, v in ipairs(regions) do
		local region = v
		if region and region ~= grpInd and region ~= self.background and region:GetObjectType() == "Texture" then
			region:SetShown(show)
		end
	end
	if not useBackgroundTexture then
		if self.background then
			self.background:Hide()
		end
		return
	end

	local backgroundTexture = ns.db.profile.unitFrames.player.groupIndicator.backgroundTexture
	local bgTexturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, backgroundTexture)
	if not bgTexturePath then
		bgTexturePath = "Interface/None"
	end
	if not self.background then
		self.background = grpInd:CreateTexture(nil, "BACKGROUND")
	end
	self.background:SetAllPoints(grpInd)
	self.background:SetTexture(bgTexturePath)
	self.background:Show()
end

BUFPlayerIndicators.GroupIndicator = BUFPlayerGroupIndicator
