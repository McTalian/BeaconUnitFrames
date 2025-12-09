---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Name: BUFFontString
local BUFBossName = {
	configPath = "unitFrames.boss.name",
	frameKey = BUFBoss.relativeToFrames.NAME,
}

BUFBossName.optionsTable = {
	type = "group",
	handler = BUFBossName,
	name = ns.L["TargetName"],
	order = BUFBoss.optionsOrder.NAME,
	args = {},
}

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss

---@class BUFDbSchema.UF.Boss.Name
ns.dbDefaults.profile.unitFrames.boss.name = {
	width = 96,
	height = 12,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFBoss.relativeToFrames.REPUTATION_BAR,
	relativePoint = "TOPRIGHT",
	xOffset = -106,
	yOffset = -1,
	useFontObjects = true,
	fontObject = "GameFontNormalSmall",
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
	justifyH = "LEFT",
	justifyV = "MIDDLE",
}

ns.options.args.boss.args.bossName = BUFBossName.optionsTable

ns.BUFFontString:ApplyMixin(BUFBossName)
ns.Mixin(BUFBossName, ns.BUFBossPositionable)

function BUFBossName:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.name = {}
			bbi.name.fontString = bbi.contentMain.Name
			bbi.name.fontString.bufOverrideParentFrame = bbi.frame
		end
	end
	self:RefreshFontStringConfig()
end

function BUFBossName:ToggleDemoMode()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ToggleDemoMode(bbi.name.fontString)
	end
end

function BUFBossName:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.name.fontString)
	end
end

function BUFBossName:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.name.fontString)
	end
end

function BUFBossName:SetFont()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFont(bbi.name.fontString)
	end
end

function BUFBossName:UpdateFontColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateFontColor(bbi.name.fontString)
	end
end

function BUFBossName:SetFontShadow()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetFontShadow(bbi.name.fontString)
	end
end

function BUFBossName:UpdateJustification()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_UpdateJustification(bbi.name.fontString)
	end
end

BUFBoss.Name = BUFBossName
