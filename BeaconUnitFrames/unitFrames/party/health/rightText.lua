---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Health
local BUFPartyHealth = BUFParty.Health

---@class BUFParty.Health.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.party.healthBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFPartyHealth.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)
ns.Mixin(rightTextHandler, ns.BUFPartyPositionable)

BUFPartyHealth.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Party.Health
ns.dbDefaults.profile.unitFrames.party.healthBar = ns.dbDefaults.profile.unitFrames.party.healthBar

ns.dbDefaults.profile.unitFrames.party.healthBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFParty.relativeToFrames.HEALTH,
	relativePoint = "RIGHT",
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

ns.options.args.party.args.healthBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bpi in ipairs(BUFParty.frames) do
			bpi.health.rightText = {}
			bpi.health.rightText.fontString = bpi.healthBarContainer.RightText
			bpi.health.rightText.fontString.bufOverrideParentFrame = bpi.frame
		end
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end

function rightTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bpi in ipairs(BUFParty.frames) do
		if self.demoMode then
			bpi.health.rightText.fontString:Show()
			bpi.health.rightText.fontString:SetText(self.demoText)
		else
			bpi.health.rightText.fontString:Hide()
		end
	end
end

function rightTextHandler:SetPosition()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetPosition(bpi.health.rightText.fontString)
	end
end

function rightTextHandler:SetSize()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetSize(bpi.health.rightText.fontString)
	end
end

function rightTextHandler:SetFont()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFont(bpi.health.rightText.fontString)
	end
end

function rightTextHandler:UpdateFontColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateFontColor(bpi.health.rightText.fontString)
	end
end

function rightTextHandler:SetFontShadow()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFontShadow(bpi.health.rightText.fontString)
	end
end

function rightTextHandler:UpdateJustification()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateJustification(bpi.health.rightText.fontString)
	end
end
