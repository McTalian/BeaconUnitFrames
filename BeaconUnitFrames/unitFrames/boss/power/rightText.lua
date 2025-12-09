---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Power
local BUFBossPower = BUFBoss.Power

---@class BUFBoss.Power.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.boss.powerBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFBossPower.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)
ns.Mixin(rightTextHandler, ns.BUFBossPositionable)

BUFBossPower.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Boss.Power
ns.dbDefaults.profile.unitFrames.boss.powerBar = ns.dbDefaults.profile.unitFrames.boss.powerBar

ns.dbDefaults.profile.unitFrames.boss.powerBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFBoss.relativeToFrames.POWER,
	relativePoint = "RIGHT",
	xOffset = -13,
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

ns.options.args.boss.args.powerBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.power.rightText = {}
			bbi.power.rightText.fontString = bbi.manaBar.RightText
			bbi.power.rightText.fontString.bufOverrideParentFrame = bbi.frame
		end
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end

function rightTextHandler:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.power.rightText.fontString)
		bbi.power.rightText.fontString:SetText(self.demoText)
	end
end

function rightTextHandler:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.power.rightText.fontString)
	end
end

function rightTextHandler:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.power.rightText.fontString)
	end
end

function rightTextHandler:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.power.rightText.fontString)
	end
end

function rightTextHandler:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.power.rightText.fontString)
	end
end

function rightTextHandler:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.power.rightText.fontString)
	end
end

function rightTextHandler:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.power.rightText.fontString)
	end
end
