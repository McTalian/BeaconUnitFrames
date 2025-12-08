---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Name: BUFFontString
local BUFToTName = {
	configPath = "unitFrames.tot.name",
	frameKey = BUFToT.relativeToFrames.NAME,
}

BUFToTName.optionsTable = {
	type = "group",
	handler = BUFToTName,
	name = ns.L["TargetName"],
	order = BUFToT.optionsOrder.NAME,
	args = {},
}

ns.BUFFontString:ApplyMixin(BUFToTName)

BUFToT.Name = BUFToTName

---@class BUFDbSchema.UF.ToT
ns.dbDefaults.profile.unitFrames.tot = ns.dbDefaults.profile.unitFrames.tot

---@class BUFDbSchema.UF.ToT.Name
ns.dbDefaults.profile.unitFrames.tot.name = {
	width = 68,
	height = 10,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFToT.relativeToFrames.PORTRAIT,
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

ns.options.args.tot.args.targetName = BUFToTName.optionsTable

function BUFToTName:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.fontString = ns.BUFToT.frame.Name
	end
	self:RefreshFontStringConfig()
end
