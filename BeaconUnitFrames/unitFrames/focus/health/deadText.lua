---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Health
local BUFFocusHealth = BUFFocus.Health

---@class BUFFocus.Health.DeadText: BUFFontString
local deadTextHandler = {
	configPath = "unitFrames.focus.healthBar.deadText",
}

deadTextHandler.optionsTable = {
	type = "group",
	handler = deadTextHandler,
	name = ns.L["Dead Text"],
	order = BUFFocusHealth.topGroupOrder.DEAD_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(deadTextHandler)

BUFFocusHealth.deadTextHandler = deadTextHandler

---@class BUFDbSchema.UF.Focus.Health
ns.dbDefaults.profile.unitFrames.focus.healthBar = ns.dbDefaults.profile.unitFrames.focus.healthBar

ns.dbDefaults.profile.unitFrames.focus.healthBar.deadText = {
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

ns.options.args.focus.args.healthBar.args.deadText = deadTextHandler.optionsTable

function deadTextHandler:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.fontString = BUFFocus.healthBarContainer.DeadText
	end
	self:RefreshFontStringConfig()
end
