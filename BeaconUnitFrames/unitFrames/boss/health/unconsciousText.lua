---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Health
local BUFBossHealth = BUFBoss.Health

---@class BUFBoss.Health.UnconsciousText: BUFFontString
local unconsciousTextHandler = {
	configPath = "unitFrames.boss.healthBar.unconsciousText",
}

unconsciousTextHandler.optionsTable = {
	type = "group",
	handler = unconsciousTextHandler,
	name = ns.L["Unconscious Text"],
	order = BUFBossHealth.topGroupOrder.UNCONSCIOUS_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(unconsciousTextHandler)
ns.Mixin(unconsciousTextHandler, ns.BUFBossPositionable)

BUFBossHealth.unconsciousTextHandler = unconsciousTextHandler

---@class BUFDbSchema.UF.Boss.Health
ns.dbDefaults.profile.unitFrames.boss.healthBar = ns.dbDefaults.profile.unitFrames.boss.healthBar

ns.dbDefaults.profile.unitFrames.boss.healthBar.unconsciousText = {
	anchorPoint = "CENTER",
	relativeTo = BUFBoss.relativeToFrames.HEALTH,
	relativePoint = "CENTER",
	xOffset = 0,
	yOffset = 0,
	useFontObjects = true,
	fontObject = "GameFontNormalSmall",
	fontColor = { 1, 0, 0, 1 },
	fontFace = "Friz Quadrata TT",
	fontSize = 12,
	fontFlags = {
		[ns.FontFlags.OUTLINE] = false,
		[ns.FontFlags.THICKOUTLINE] = false,
		[ns.FontFlags.MONOCHROME] = false,
	},
	fontShadowColor = { 0, 0, 0, 1 },
	fontShadowOffsetX = 1,
	fontShadowOffsetY = -1,
}

ns.options.args.boss.args.healthBar.args.unconsciousText = unconsciousTextHandler.optionsTable

function unconsciousTextHandler:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.health.unconsciousText = {}
			bbi.health.unconsciousText.fontString = bbi.healthBarContainer.UnconsciousText
			bbi.health.unconsciousText.fontString.bufOverrideParentFrame = bbi.frame
		end
	end
	self:RefreshFontStringConfig()
end

function unconsciousTextHandler:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bbi in ipairs(BUFBoss.frames) do
		if self.demoMode then
			bbi.health.unconsciousText.fontString:Show()
			bbi.health.unconsciousText.fontString:SetText(self.demoText)
		else
			bbi.health.unconsciousText.fontString:Hide()
		end
	end
end

function unconsciousTextHandler:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.health.unconsciousText.fontString)
	end
end

function unconsciousTextHandler:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.health.unconsciousText.fontString)
	end
end

function unconsciousTextHandler:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.health.unconsciousText.fontString)
	end
end

function unconsciousTextHandler:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.health.unconsciousText.fontString)
	end
end

function unconsciousTextHandler:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.health.unconsciousText.fontString)
	end
end

function unconsciousTextHandler:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.health.unconsciousText.fontString)
	end
end
