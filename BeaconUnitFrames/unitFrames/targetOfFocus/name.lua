---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Name: BUFFontString
local BUFToFocusName = {
	configPath = "unitFrames.tofocus.name",
	frameKey = BUFToFocus.relativeToFrames.NAME,
}

BUFToFocusName.optionsTable = {
	type = "group",
	handler = BUFToFocusName,
	name = ns.L["TargetName"],
	order = BUFToFocus.optionsOrder.NAME,
	args = {},
}

ns.BUFFontString:ApplyMixin(BUFToFocusName)

BUFToFocus.Name = BUFToFocusName

---@class BUFDbSchema.UF.ToFocus
ns.dbDefaults.profile.unitFrames.tofocus = ns.dbDefaults.profile.unitFrames.tofocus

---@class BUFDbSchema.UF.ToFocus.Name
ns.dbDefaults.profile.unitFrames.tofocus.name = {
	width = 68,
	height = 10,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFToFocus.relativeToFrames.PORTRAIT,
	relativePoint = "TOPRIGHT",
	xOffset = 2,
	yOffset = 0,
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

ns.options.args.tofocus.args.targetName = BUFToFocusName.optionsTable

function BUFToFocusName:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.fontString = ns.BUFToFocus.frame.Name
	end
	self:RefreshFontStringConfig()
end
