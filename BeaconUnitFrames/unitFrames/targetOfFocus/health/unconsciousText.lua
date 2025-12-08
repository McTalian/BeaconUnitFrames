---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Health
local BUFToFocusHealth = BUFToFocus.Health

---@class BUFToFocus.Health.UnconsciousText: BUFFontString
local unconsciousTextHandler = {
	configPath = "unitFrames.tofocus.healthBar.unconsciousText",
}

unconsciousTextHandler.optionsTable = {
	type = "group",
	handler = unconsciousTextHandler,
	name = ns.L["Unconscious Text"],
	order = BUFToFocusHealth.topGroupOrder.UNCONSCIOUS_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(unconsciousTextHandler)

BUFToFocusHealth.unconsciousTextHandler = unconsciousTextHandler

---@class BUFDbSchema.UF.ToFocus.Health
ns.dbDefaults.profile.unitFrames.tofocus.healthBar = ns.dbDefaults.profile.unitFrames.tofocus.healthBar

ns.dbDefaults.profile.unitFrames.tofocus.healthBar.unconsciousText = {
	anchorPoint = "CENTER",
	relativeTo = BUFToFocus.relativeToFrames.HEALTH,
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

ns.options.args.tofocus.args.healthBar.args.unconsciousText = unconsciousTextHandler.optionsTable

function unconsciousTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.fontString = BUFToFocus.healthBar.UnconsciousText
	end
	self:RefreshFontStringConfig()
end
