---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Level: BUFFontString
local BUFTargetLevel = {
	configPath = "unitFrames.target.level",
}

BUFTargetLevel.optionsTable = {
	type = "group",
	handler = BUFTargetLevel,
	name = LEVEL,
	order = BUFTarget.optionsOrder.LEVEL,
	args = {},
}

ns.BUFFontString:ApplyMixin(BUFTargetLevel)

BUFTarget.Level = BUFTargetLevel

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Level
ns.dbDefaults.profile.unitFrames.target.level = {
	anchorPoint = "TOPLEFT",
	relativeTo = ns.DEFAULT,
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

ns.options.args.target.args.level = BUFTargetLevel.optionsTable

function BUFTargetLevel:RefreshConfig()
	if not self.fontString then
		self.fontString = BUFTarget.contentMain.LevelText
		self.defaultRelativeTo = BUFTarget.contentMain.ReputationColor

		BUFTarget:SecureHook(self.fontString, "SetVertexColor", function()
			self:UpdateFontColor()
		end)
	end
	self:RefreshFontStringConfig()
end
