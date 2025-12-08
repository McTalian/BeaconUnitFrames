---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Portrait: BUFFramePortrait
local BUFToFocusPortrait = {
	configPath = "unitFrames.tofocus.portrait",
	frameKey = BUFToFocus.relativeToFrames.PORTRAIT,
	module = BUFToFocus,
}

BUFToFocusPortrait.optionsTable = {
	type = "group",
	handler = BUFToFocusPortrait,
	name = ns.L["Portrait"],
	order = BUFToFocus.optionsOrder.PORTRAIT,
	args = {},
}

---@class BUFDbSchema.UF.ToFocus.Portrait
BUFToFocusPortrait.dbDefaults = {
	enabled = true,
	width = 37,
	height = 37,
	scale = 1.0,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFToFocus.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 5,
	yOffset = -5,
	mask = "interface/hud/uiunitframeplayerportraitmask.blp",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

ns.BUFFramePortrait:ApplyMixin(BUFToFocusPortrait)

---@class BUFDbSchema.UF.ToFocus
ns.dbDefaults.profile.unitFrames.tofocus = ns.dbDefaults.profile.unitFrames.tofocus
ns.dbDefaults.profile.unitFrames.tofocus.portrait = BUFToFocusPortrait.dbDefaults

ns.options.args.tofocus.args.portrait = BUFToFocusPortrait.optionsTable

function BUFToFocusPortrait:RefreshConfig()
	if not self.initialized then
		BUFToFocus.FrameInit(self)

		self.texture = BUFToFocus.frame.Portrait
		self.maskTexture = BUFToFocus.frame.PortraitMask
	end
	self:RefreshPortraitConfig()
end

BUFToFocus.Portrait = BUFToFocusPortrait
