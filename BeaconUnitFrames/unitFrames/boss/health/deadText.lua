---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Health
local BUFBossHealth = BUFBoss.Health

---@class BUFBoss.Health.DeadText: BUFFontString
local deadTextHandler = {
	configPath = "unitFrames.boss.healthBar.deadText",
}

deadTextHandler.optionsTable = {
	type = "group",
	handler = deadTextHandler,
	name = ns.L["Dead Text"],
	order = BUFBossHealth.topGroupOrder.DEAD_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(deadTextHandler)
ns.Mixin(deadTextHandler, ns.BUFBossPositionable)

BUFBossHealth.deadTextHandler = deadTextHandler

---@class BUFDbSchema.UF.Boss.Health
ns.dbDefaults.profile.unitFrames.boss.healthBar = ns.dbDefaults.profile.unitFrames.boss.healthBar

ns.dbDefaults.profile.unitFrames.boss.healthBar.deadText = {
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

ns.options.args.boss.args.healthBar.args.deadText = deadTextHandler.optionsTable

function deadTextHandler:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.health.deadText = {}
			bbi.health.deadText.fontString = bbi.healthBarContainer.DeadText
			bbi.health.deadText.fontString.bufOverrideParentFrame = bbi.frame
		end
	end
	self:RefreshFontStringConfig()
end

function deadTextHandler:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.health.deadText.fontString)
	end
end

function deadTextHandler:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.health.deadText.fontString)
	end
end

function deadTextHandler:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.health.deadText.fontString)
	end
end

function deadTextHandler:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.health.deadText.fontString)
	end
end

function deadTextHandler:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.health.deadText.fontString)
	end
end

function deadTextHandler:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.health.deadText.fontString)
	end
end

function deadTextHandler:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.health.deadText.fontString)
	end
end
