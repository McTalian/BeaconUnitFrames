---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Health
local BUFToFocusHealth = BUFToFocus.Health

---@class BUFToFocus.Health.DeadText: BUFFontString
local deadTextHandler = {
	configPath = "unitFrames.tofocus.healthBar.deadText",
}

deadTextHandler.optionsTable = {
	type = "group",
	handler = deadTextHandler,
	name = ns.L["Dead Text"],
	order = BUFToFocusHealth.topGroupOrder.DEAD_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(deadTextHandler)

BUFToFocusHealth.deadTextHandler = deadTextHandler

---@class BUFDbSchema.UF.ToFocus.Health
ns.dbDefaults.profile.unitFrames.tofocus.healthBar = ns.dbDefaults.profile.unitFrames.tofocus.healthBar

ns.dbDefaults.profile.unitFrames.tofocus.healthBar.deadText = {
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

ns.options.args.tofocus.args.healthBar.args.deadText = deadTextHandler.optionsTable

function deadTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.fontString = BUFToFocus.healthBar.DeadText
	end
	self:RefreshFontStringConfig()
end
