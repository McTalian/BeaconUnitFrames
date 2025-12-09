---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Power
local BUFBossPower = BUFBoss.Power

---@class BUFBoss.Power.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.boss.powerBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFBossPower.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)
ns.Mixin(leftTextHandler, ns.BUFBossPositionable)

BUFBossPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Boss.Power
ns.dbDefaults.profile.unitFrames.boss.powerBar = ns.dbDefaults.profile.unitFrames.boss.powerBar

ns.dbDefaults.profile.unitFrames.boss.powerBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFBoss.relativeToFrames.POWER,
	relativePoint = "LEFT",
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

ns.options.args.boss.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.power.leftText = {}
			bbi.power.leftText.fontString = bbi.manaBar.LeftText
			bbi.power.leftText.fontString.bufOverrideParentFrame = bbi.frame
		end
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end

function leftTextHandler:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.power.leftText.fontString)
		bbi.power.leftText.fontString:SetText(self.demoText)
	end
end

function leftTextHandler:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.power.leftText.fontString)
	end
end

function leftTextHandler:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.power.leftText.fontString)
	end
end

function leftTextHandler:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.power.leftText.fontString)
	end
end

function leftTextHandler:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.power.leftText.fontString)
	end
end

function leftTextHandler:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.power.leftText.fontString)
	end
end

function leftTextHandler:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.power.leftText.fontString)
	end
end
