---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Health
local BUFPartyHealth = BUFParty.Health

---@class BUFParty.Health.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.party.healthBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFPartyHealth.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)
ns.Mixin(leftTextHandler, ns.BUFPartyPositionable)

BUFPartyHealth.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Party.Health
ns.dbDefaults.profile.unitFrames.party.healthBar = ns.dbDefaults.profile.unitFrames.party.healthBar

ns.dbDefaults.profile.unitFrames.party.healthBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFParty.relativeToFrames.HEALTH,
	relativePoint = "LEFT",
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

ns.options.args.party.args.healthBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bpi in ipairs(BUFParty.frames) do
			bpi.health.leftText = {}
			bpi.health.leftText.fontString = bpi.healthBarContainer.LeftText
			bpi.health.leftText.fontString.bufOverrideParentFrame = bpi.frame
		end
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end

function leftTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bpi in ipairs(BUFParty.frames) do
		if self.demoMode then
			bpi.health.leftText.fontString:Show()
			bpi.health.leftText.fontString:SetText(self.demoText)
		else
			bpi.health.leftText.fontString:Hide()
		end
	end
end

function leftTextHandler:SetPosition()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetPosition(bpi.health.leftText.fontString)
	end
end

function leftTextHandler:SetSize()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetSize(bpi.health.leftText.fontString)
	end
end

function leftTextHandler:SetFont()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFont(bpi.health.leftText.fontString)
	end
end

function leftTextHandler:UpdateFontColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateFontColor(bpi.health.leftText.fontString)
	end
end

function leftTextHandler:SetFontShadow()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFontShadow(bpi.health.leftText.fontString)
	end
end

function leftTextHandler:UpdateJustification()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateJustification(bpi.health.leftText.fontString)
	end
end
