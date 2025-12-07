---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Level: BUFFontString
local BUFFocusLevel = {
	configPath = "unitFrames.focus.level",
	frameKey = BUFFocus.relativeToFrames.LEVEL,
}

BUFFocusLevel.optionsTable = {
	type = "group",
	handler = BUFFocusLevel,
	name = LEVEL,
	order = BUFFocus.optionsOrder.LEVEL,
	args = {},
}

---@class BUFDbSchema.UF.Focus.Level
BUFFocusLevel.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFFocus.relativeToFrames.REPUTATION_BAR,
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

ns.BUFFontString:ApplyMixin(BUFFocusLevel)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.level = BUFFocusLevel.dbDefaults

ns.options.args.focus.args.level = BUFFocusLevel.optionsTable

function BUFFocusLevel:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.fontString = BUFFocus.contentMain.LevelText

		BUFFocus:SecureHook(self.fontString, "SetVertexColor", function()
			self:UpdateFontColor()
		end)
	end
	self:RefreshFontStringConfig()
end

BUFFocus.Level = BUFFocusLevel
