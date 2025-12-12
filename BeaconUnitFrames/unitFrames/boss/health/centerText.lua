---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Health
local BUFBossHealth = BUFBoss.Health

---@class BUFBoss.Health.CenterText: BUFFontString
local centerTextHandler = {
	configPath = "unitFrames.boss.healthBar.centerText",
}

centerTextHandler.optionsTable = {
	type = "group",
	handler = centerTextHandler,
	name = ns.L["Center Text"],
	order = BUFBossHealth.topGroupOrder.CENTER_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(centerTextHandler)
ns.Mixin(centerTextHandler, ns.BUFBossPositionable)

BUFBossHealth.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Boss.Health
ns.dbDefaults.profile.unitFrames.boss.healthBar = ns.dbDefaults.profile.unitFrames.boss.healthBar

ns.dbDefaults.profile.unitFrames.boss.healthBar.centerText = {
	anchorPoint = "CENTER",
	relativeTo = BUFBoss.relativeToFrames.HEALTH,
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

ns.options.args.boss.args.healthBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.health.centerText = {}
			bbi.health.centerText.fontString = bbi.healthBarContainer.HealthBarText
			bbi.health.centerText.fontString.bufOverrideParentFrame = bbi.frame
		end
		self.demoText = "123k / 123k"
	end
	self:RefreshFontStringConfig()
end

function centerTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bbi in ipairs(BUFBoss.frames) do
		if self.demoMode then
			bbi.health.centerText.fontString:Show()
			bbi.health.centerText.fontString:SetText(self.demoText)
		else
			bbi.health.centerText.fontString:Hide()
		end
	end
end

function centerTextHandler:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.health.centerText.fontString)
	end
end

function centerTextHandler:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.health.centerText.fontString)
	end
end

function centerTextHandler:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.health.centerText.fontString)
	end
end

function centerTextHandler:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.health.centerText.fontString)
	end
end

function centerTextHandler:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.health.centerText.fontString)
	end
end

function centerTextHandler:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.health.centerText.fontString)
	end
end
