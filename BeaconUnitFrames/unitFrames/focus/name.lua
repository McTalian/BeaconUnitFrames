---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Name: BUFFontString
local BUFFocusName = {
	configPath = "unitFrames.focus.name",
	frameKey = BUFFocus.relativeToFrames.NAME,
}

BUFFocusName.optionsTable = {
	type = "group",
	handler = BUFFocusName,
	name = ns.L["FocusName"],
	order = BUFFocus.optionsOrder.NAME,
	args = {},
}

ns.BUFFontString:ApplyMixin(BUFFocusName)

BUFFocus.Name = BUFFocusName

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus

---@class BUFDbSchema.UF.Focus.Name
ns.dbDefaults.profile.unitFrames.focus.name = {
	width = 96,
	height = 12,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFFocus.relativeToFrames.REPUTATION_BAR,
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

ns.options.args.focus.args.focusName = BUFFocusName.optionsTable

function BUFFocusName:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.fontString = ns.BUFFocus.contentMain.Name
	end
	self:RefreshFontStringConfig()
end
