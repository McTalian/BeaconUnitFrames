---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Health
local BUFToTHealth = BUFToT.Health

---@class BUFToT.Health.DeadText: BUFFontString
local deadTextHandler = {
	configPath = "unitFrames.tot.healthBar.deadText",
}

deadTextHandler.optionsTable = {
	type = "group",
	handler = deadTextHandler,
	name = ns.L["Dead Text"],
	order = BUFToTHealth.topGroupOrder.DEAD_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(deadTextHandler)

BUFToTHealth.deadTextHandler = deadTextHandler

---@class BUFDbSchema.UF.ToT.Health
ns.dbDefaults.profile.unitFrames.tot.healthBar = ns.dbDefaults.profile.unitFrames.tot.healthBar

ns.dbDefaults.profile.unitFrames.tot.healthBar.deadText = {
	anchorPoint = "CENTER",
	relativeTo = BUFToT.relativeToFrames.HEALTH,
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

ns.options.args.tot.args.healthBar.args.deadText = deadTextHandler.optionsTable

function deadTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.fontString = BUFToT.healthBar.DeadText
	end
	self:RefreshFontStringConfig()
end
