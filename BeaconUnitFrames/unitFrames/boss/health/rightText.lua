---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Health
local BUFBossHealth = BUFBoss.Health

---@class BUFBoss.Health.RightText: BUFFontString
local rightTextHandler = {
	configPath = "unitFrames.boss.healthBar.rightText",
}

rightTextHandler.optionsTable = {
	type = "group",
	handler = rightTextHandler,
	name = ns.L["Right Text"],
	order = BUFBossHealth.topGroupOrder.RIGHT_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(rightTextHandler)
ns.Mixin(rightTextHandler, ns.BUFBossPositionable)

BUFBossHealth.rightTextHandler = rightTextHandler

---@class BUFDbSchema.UF.Boss.Health
ns.dbDefaults.profile.unitFrames.boss.healthBar = ns.dbDefaults.profile.unitFrames.boss.healthBar

ns.dbDefaults.profile.unitFrames.boss.healthBar.rightText = {
	anchorPoint = "RIGHT",
	relativeTo = BUFBoss.relativeToFrames.HEALTH,
	relativePoint = "RIGHT",
	xOffset = -5,
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

ns.options.args.boss.args.healthBar.args.rightText = rightTextHandler.optionsTable

function rightTextHandler:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.health.rightText = {}
			bbi.health.rightText.fontString = bbi.healthBarContainer.RightText
			bbi.health.rightText.fontString.bufOverrideParentFrame = bbi.frame
		end
		self.demoText = "123k"
	end
	self:RefreshFontStringConfig()
end

function rightTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bbi in ipairs(BUFBoss.frames) do
		if self.demoMode then
			bbi.health.rightText.fontString:Show()
			bbi.health.rightText.fontString:SetText(self.demoText)
		else
			bbi.health.rightText.fontString:Hide()
		end
	end
end

function rightTextHandler:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.health.rightText.fontString)
	end
end

function rightTextHandler:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.health.rightText.fontString)
	end
end

function rightTextHandler:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.health.rightText.fontString)
	end
end

function rightTextHandler:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.health.rightText.fontString)
	end
end

function rightTextHandler:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.health.rightText.fontString)
	end
end

function rightTextHandler:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.health.rightText.fontString)
	end
end
