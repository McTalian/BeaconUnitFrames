---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Health
local BUFToTHealth = BUFToT.Health

---@class BUFToT.Health.UnconsciousText: BUFFontString
local unconsciousTextHandler = {
	configPath = "unitFrames.tot.healthBar.unconsciousText",
}

unconsciousTextHandler.optionsTable = {
	type = "group",
	handler = unconsciousTextHandler,
	name = ns.L["Unconscious Text"],
	order = BUFToTHealth.topGroupOrder.UNCONSCIOUS_TEXT,
	args = {},
}

ns.BUFFontString:ApplyMixin(unconsciousTextHandler)

BUFToTHealth.unconsciousTextHandler = unconsciousTextHandler

---@class BUFDbSchema.UF.ToT.Health
ns.dbDefaults.profile.unitFrames.tot.healthBar = ns.dbDefaults.profile.unitFrames.tot.healthBar

ns.dbDefaults.profile.unitFrames.tot.healthBar.unconsciousText = {
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

ns.options.args.tot.args.healthBar.args.unconsciousText = unconsciousTextHandler.optionsTable

function unconsciousTextHandler:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.fontString = BUFToT.healthBar.UnconsciousText
	end
	self:RefreshFontStringConfig()
end
