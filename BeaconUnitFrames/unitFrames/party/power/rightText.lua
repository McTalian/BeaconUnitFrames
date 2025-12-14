---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Power
local BUFPartyPower = BUFParty.Power

---@class BUFParty.Power.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.party.powerBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFPartyPower.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)
ns.Mixin(rightTextHandler, ns.BUFPartyPositionable)

BUFPartyPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Party.Power
ns.dbDefaults.profile.unitFrames.party.powerBar = ns.dbDefaults.profile.unitFrames.party.powerBar

ns.dbDefaults.profile.unitFrames.party.powerBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFParty.relativeToFrames.POWER,
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

ns.options.args.party.args.powerBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bpi in ipairs(BUFParty.frames) do
			bpi.power.rightText = {}
			bpi.power.rightText.fontString = bpi.manaBar.RightText
			bpi.power.rightText.fontString.bufOverrideParentFrame = bpi.frame
		end
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end

function rightTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bpi in ipairs(BUFParty.frames) do
		if self.demoMode then
			bpi.power.rightText.fontString:Show()
			bpi.power.rightText.fontString:SetText(self.demoText)
		else
			bpi.power.rightText.fontString:Hide()
		end
	end
end

function rightTextHandler:SetPosition()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetPosition(bpi.power.rightText.fontString)
	end
end

function rightTextHandler:SetSize()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetSize(bpi.power.rightText.fontString)
	end
end

function rightTextHandler:SetFont()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFont(bpi.power.rightText.fontString)
	end
end

function rightTextHandler:UpdateFontColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateFontColor(bpi.power.rightText.fontString)
	end
end

function rightTextHandler:SetFontShadow()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_SetFontShadow(bpi.power.rightText.fontString)
	end
end

function rightTextHandler:UpdateJustification()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_UpdateJustification(bpi.power.rightText.fontString)
	end
end
