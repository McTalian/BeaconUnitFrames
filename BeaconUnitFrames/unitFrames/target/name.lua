---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Name: BUFFontString
local BUFTargetName = {
    configPath = "unitFrames.target.name",
}

BUFTargetName.optionsTable = {
    type = "group",
    handler = BUFTargetName,
    name = ns.L["Target Name"],
    order = BUFTarget.optionsOrder.NAME,
    args = {}
}

ns.BUFFontString:ApplyMixin(BUFTargetName)

BUFTarget.Name = BUFTargetName

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Name
ns.dbDefaults.profile.unitFrames.target.name = {
    width = 96,
    height = 12,
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
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

ns.options.args.target.args.targetName = BUFTargetName.optionsTable

function BUFTargetName:RefreshConfig()
    if not self.fontString then
        self.fontString = ns.BUFTarget.contentMain.Name
        self.defaultRelativeTo = ns.BUFTarget.contentMain.ReputationColor
        self.defaultRelativePoint = "TOPRIGHT"
    end
    self:RefreshFontStringConfig()
end
