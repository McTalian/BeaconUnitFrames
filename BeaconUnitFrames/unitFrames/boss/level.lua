---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Level: BUFFontString
local BUFBossLevel = {
	configPath = "unitFrames.boss.level",
	frameKey = BUFBoss.relativeToFrames.LEVEL,
}

BUFBossLevel.optionsTable = {
	type = "group",
	handler = BUFBossLevel,
	name = LEVEL,
	order = BUFBoss.optionsOrder.LEVEL,
	args = {},
}

---@class BUFDbSchema.UF.Boss.Level
BUFBossLevel.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFBoss.relativeToFrames.REPUTATION_BAR,
	relativePoint = "TOPRIGHT",
	xOffset = -133,
	yOffset = -2,
	useFontObjects = true,
	fontObject = "GameNormalNumberFont",
	fontColor = { NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.a },
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
	justifyH = "CENTER",
}

ns.BUFFontString:ApplyMixin(BUFBossLevel)
ns.Mixin(BUFBossLevel, ns.BUFBossPositionable)

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss
ns.dbDefaults.profile.unitFrames.boss.level = BUFBossLevel.dbDefaults

ns.options.args.boss.args.level = BUFBossLevel.optionsTable

function BUFBossLevel:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for i, bbi in ipairs(BUFBoss.frames) do
			bbi.level = {}
			bbi.level.fontString = bbi.contentMain.LevelText
			bbi.level.fontString.bufOverrideParentFrame = bbi.frame
			BUFBoss:SecureHook(bbi.level.fontString, "SetVertexColor", function()
				self:_UpdateFontColor(bbi.level.fontString)
			end)
		end
	end
	self:RefreshFontStringConfig()
end

function BUFBossLevel:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.level.fontString)
	end
end

function BUFBossLevel:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.level.fontString)
	end
end

function BUFBossLevel:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.level.fontString)
	end
end

function BUFBossLevel:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.level.fontString)
	end
end

function BUFBossLevel:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.level.fontString)
	end
end

function BUFBossLevel:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.level.fontString)
	end
end

function BUFBossLevel:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.level.fontString)
	end
end

BUFBoss.Level = BUFBossLevel
