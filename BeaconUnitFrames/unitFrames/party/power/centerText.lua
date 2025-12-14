---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Power
local BUFPartyPower = BUFParty.Power

---@class BUFParty.Power.CenterText: BUFFontString
local centerTextHandler = {
	configPath = "unitFrames.party.powerBar.centerText",
}

centerTextHandler.optionsTable = {
	type = "group",
	handler = centerTextHandler,
	name = ns.L["Center Text"],
	order = BUFPartyPower.topGroupOrder.CENTER_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(centerTextHandler)
ns.Mixin(centerTextHandler, ns.BUFPartyPositionable)

BUFPartyPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Party.Power
ns.dbDefaults.profile.unitFrames.party.powerBar = ns.dbDefaults.profile.unitFrames.party.powerBar

ns.dbDefaults.profile.unitFrames.party.powerBar.centerText = {
	anchorPoint = "CENTER",
	relativeTo = BUFParty.relativeToFrames.POWER,
	relativePoint = "CENTER",
	xOffset = 2,
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

ns.options.args.party.args.powerBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bpi in ipairs(BUFParty.frames) do
			bpi.power.centerText = {}
			bpi.power.centerText.fontString = bpi.manaBar.CenterText
			bpi.power.centerText.fontString.bufOverrideParentFrame = bpi.frame
		end
		self.demoText = "123k / 123k"
	end
	self:RefreshFontStringConfig()
end

function centerTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bpi in ipairs(BUFParty.frames) do
		if self.demoMode then
			bpi.power.centerText.fontString:Show()
			bpi.power.centerText.fontString:SetText(self.demoText)
		else
			bpi.power.centerText.fontString:Hide()
		end
	end
end

function centerTextHandler:SetPosition()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetPosition(bpi.power.centerText.fontString)
	end
end

function centerTextHandler:SetSize()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetSize(bpi.power.centerText.fontString)
	end
end

function centerTextHandler:SetFont()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFont(bpi.power.centerText.fontString)
	end
end

function centerTextHandler:UpdateFontColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateFontColor(bpi.power.centerText.fontString)
	end
end

function centerTextHandler:SetFontShadow()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFontShadow(bpi.power.centerText.fontString)
	end
end

function centerTextHandler:UpdateJustification()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateJustification(bpi.power.centerText.fontString)
	end
end
