---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Health
local BUFPartyHealth = BUFParty.Health

---@class BUFParty.Health.CenterText: BUFFontString
local centerTextHandler = {
	configPath = "unitFrames.party.healthBar.centerText",
}

centerTextHandler.optionsTable = {
	type = "group",
	handler = centerTextHandler,
	name = ns.L["Center Text"],
	order = BUFPartyHealth.topGroupOrder.CENTER_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(centerTextHandler)
ns.Mixin(centerTextHandler, ns.BUFPartyPositionable)

BUFPartyHealth.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Party.Health
ns.dbDefaults.profile.unitFrames.party.healthBar = ns.dbDefaults.profile.unitFrames.party.healthBar

ns.dbDefaults.profile.unitFrames.party.healthBar.centerText = {
	anchorPoint = "CENTER",
	relativeTo = BUFParty.relativeToFrames.HEALTH,
	relativePoint = "CENTER",
	xOffset = 0,
	yOffset = 0,
	useFontObjects = true,
	fontObject = "TextStatusBarText",
	fontColor = { 1, 1, 1, 1 },
	fontFace = "Friz Quadrata TT",
	fontSize = 10,
	fontFlags = {
		[ns.FontFlags.OUTLINE] = false,
		[ns.FontFlags.THICKOUTLINE] = false,
		[ns.FontFlags.MONOCHROME] = false,
	},
	fontShadowColor = { 0, 0, 0, 1 },
	fontShadowOffsetX = 1,
	fontShadowOffsetY = -1,
}

ns.options.args.party.args.healthBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bpi in ipairs(BUFParty.frames) do
			bpi.health.centerText = {}
			bpi.health.centerText.fontString = bpi.healthBarContainer.CenterText
			bpi.health.centerText.fontString.bufOverrideParentFrame = bpi.frame
		end
		self.demoText = "123k / 123k"
	end
	self:RefreshFontStringConfig()
end

function centerTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bpi in ipairs(BUFParty.frames) do
		if self.demoMode then
			bpi.health.centerText.fontString:Show()
			bpi.health.centerText.fontString:SetText(self.demoText)
		else
			bpi.health.centerText.fontString:Hide()
		end
	end
end

function centerTextHandler:SetPosition()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetPosition(bpi.health.centerText.fontString)
	end
end

function centerTextHandler:SetSize()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetSize(bpi.health.centerText.fontString)
	end
end

function centerTextHandler:SetFont()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFont(bpi.health.centerText.fontString)
	end
end

function centerTextHandler:UpdateFontColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateFontColor(bpi.health.centerText.fontString)
	end
end

function centerTextHandler:SetFontShadow()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFontShadow(bpi.health.centerText.fontString)
	end
end

function centerTextHandler:UpdateJustification()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateJustification(bpi.health.centerText.fontString)
	end
end
