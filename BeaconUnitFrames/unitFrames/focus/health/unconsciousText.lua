---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Health
local BUFFocusHealth = BUFFocus.Health

---@class BUFFocus.Health.UnconsciousText: BUFFontString
local unconsciousTextHandler = {
	configPath = "unitFrames.focus.healthBar.unconsciousText",
}

unconsciousTextHandler.optionsTable = {
	type = "group",
	handler = unconsciousTextHandler,
	name = ns.L["Unconscious Text"],
	order = BUFFocusHealth.topGroupOrder.UNCONSCIOUS_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(unconsciousTextHandler)

BUFFocusHealth.unconsciousTextHandler = unconsciousTextHandler

---@class BUFDbSchema.UF.Focus.Health
ns.dbDefaults.profile.unitFrames.focus.healthBar = ns.dbDefaults.profile.unitFrames.focus.healthBar

ns.dbDefaults.profile.unitFrames.focus.healthBar.unconsciousText = {
	anchorPoint = "CENTER",
	relativeTo = BUFFocus.relativeToFrames.HEALTH,
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

ns.options.args.focus.args.healthBar.args.unconsciousText = unconsciousTextHandler.optionsTable

function unconsciousTextHandler:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.fontString = BUFFocus.healthBarContainer.UnconsciousText
	end
	self:RefreshFontStringConfig()
end
