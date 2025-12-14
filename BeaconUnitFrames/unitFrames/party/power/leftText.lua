---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Power
local BUFPartyPower = BUFParty.Power

---@class BUFParty.Power.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.party.powerBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFPartyPower.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)
ns.Mixin(leftTextHandler, ns.BUFPartyPositionable)

BUFPartyPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Party.Power
ns.dbDefaults.profile.unitFrames.party.powerBar = ns.dbDefaults.profile.unitFrames.party.powerBar

ns.dbDefaults.profile.unitFrames.party.powerBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFParty.relativeToFrames.POWER,
	relativePoint = "LEFT",
	xOffset = 4,
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

ns.options.args.party.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bpi in ipairs(BUFParty.frames) do
			bpi.power.leftText = {}
			bpi.power.leftText.fontString = bpi.manaBar.LeftText
			bpi.power.leftText.fontString.bufOverrideParentFrame = bpi.frame
		end
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end

function leftTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bpi in ipairs(BUFParty.frames) do
		if self.demoMode then
			bpi.power.leftText:Show()
			bpi.power.leftText.fontString:SetText(self.demoText)
		else
			bpi.power.leftText:Hide()
		end
	end
end

function leftTextHandler:SetPosition()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetPosition(bpi.power.leftText.fontString)
	end
end

function leftTextHandler:SetSize()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetSize(bpi.power.leftText.fontString)
	end
end

function leftTextHandler:SetFont()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFont(bpi.power.leftText.fontString)
	end
end

function leftTextHandler:UpdateFontColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateFontColor(bpi.power.leftText.fontString)
	end
end

function leftTextHandler:SetFontShadow()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFontShadow(bpi.power.leftText.fontString)
	end
end

function leftTextHandler:UpdateJustification()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateJustification(bpi.power.leftText.fontString)
	end
end
