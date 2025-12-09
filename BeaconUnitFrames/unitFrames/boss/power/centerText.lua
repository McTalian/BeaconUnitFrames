---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Power
local BUFBossPower = BUFBoss.Power

---@class BUFBoss.Power.CenterText: BUFFontString
local centerTextHandler = {
	configPath = "unitFrames.boss.powerBar.centerText",
}

centerTextHandler.optionsTable = {
	type = "group",
	handler = centerTextHandler,
	name = ns.L["Center Text"],
	order = BUFBossPower.topGroupOrder.CENTER_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(centerTextHandler)
ns.Mixin(centerTextHandler, ns.BUFBossPositionable)

BUFBossPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Boss.Power
ns.dbDefaults.profile.unitFrames.boss.powerBar = ns.dbDefaults.profile.unitFrames.boss.powerBar

ns.dbDefaults.profile.unitFrames.boss.powerBar.centerText = {
	anchorPoint = "CENTER",
	relativeTo = BUFBoss.relativeToFrames.POWER,
	relativePoint = "CENTER",
	xOffset = -4,
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

ns.options.args.boss.args.powerBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.power.centerText = {}
			bbi.power.centerText.fontString = bbi.manaBar.ManaBarText
			bbi.power.centerText.fontString.bufOverrideParentFrame = bbi.frame
		end
		self.demoText = "123k / 123k"
	end
	self:RefreshFontStringConfig()
end

function centerTextHandler:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.power.centerText.fontString)
		bbi.power.centerText.fontString:SetText(self.demoText)
	end
end

function centerTextHandler:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.power.centerText.fontString)
	end
end

function centerTextHandler:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.power.centerText.fontString)
	end
end

function centerTextHandler:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.power.centerText.fontString)
	end
end

function centerTextHandler:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.power.centerText.fontString)
	end
end

function centerTextHandler:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.power.centerText.fontString)
	end
end

function centerTextHandler:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.power.centerText.fontString)
	end
end
