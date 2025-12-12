---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Health
local BUFBossHealth = BUFBoss.Health

---@class BUFBoss.Health.LeftText: BUFFontString
local leftTextHandler = {
	configPath = "unitFrames.boss.healthBar.leftText",
}

leftTextHandler.optionsTable = {
	type = "group",
	handler = leftTextHandler,
	name = ns.L["Left Text"],
	order = BUFBossHealth.topGroupOrder.LEFT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(leftTextHandler)
ns.Mixin(leftTextHandler, ns.BUFBossPositionable)

BUFBossHealth.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Boss.Health
ns.dbDefaults.profile.unitFrames.boss.healthBar = ns.dbDefaults.profile.unitFrames.boss.healthBar

ns.dbDefaults.profile.unitFrames.boss.healthBar.leftText = {
	anchorPoint = "LEFT",
	relativeTo = BUFBoss.relativeToFrames.HEALTH,
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

ns.options.args.boss.args.healthBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.health.leftText = {}
			bbi.health.leftText.fontString = bbi.healthBarContainer.LeftText
			bbi.health.leftText.fontString.bufOverrideParentFrame = bbi.frame
		end
		self.demoText = "100%"
	end
	self:RefreshFontStringConfig()
end

function leftTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bbi in ipairs(BUFBoss.frames) do
		if self.demoMode then
			bbi.health.leftText.fontString:Show()
			bbi.health.leftText.fontString:SetText(self.demoText)
		else
			bbi.health.leftText.fontString:Hide()
		end
	end
end

function leftTextHandler:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.health.leftText.fontString)
	end
end

function leftTextHandler:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.health.leftText.fontString)
	end
end

function leftTextHandler:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.health.leftText.fontString)
	end
end

function leftTextHandler:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.health.leftText.fontString)
	end
end

function leftTextHandler:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.health.leftText.fontString)
	end
end

function leftTextHandler:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.health.leftText.fontString)
	end
end
