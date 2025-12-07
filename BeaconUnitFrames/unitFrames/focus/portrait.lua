---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Portrait: BUFFramePortrait
local BUFFocusPortrait = {
	configPath = "unitFrames.focus.portrait",
	frameKey = BUFFocus.relativeToFrames.PORTRAIT,
	module = BUFFocus,
}

BUFFocusPortrait.optionsTable = {
	type = "group",
	handler = BUFFocusPortrait,
	name = ns.L["Portrait"],
	order = BUFFocus.optionsOrder.PORTRAIT,
	args = {},
}

---@class BUFDbSchema.UF.Focus.Portrait
BUFFocusPortrait.dbDefaults = {
	enabled = true,
	width = 58,
	height = 58,
	scale = 1.0,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFFocus.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -26,
	yOffset = -19,
	mask = "interface/hud/uiunitframeplayerportraitmask.blp",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

ns.BUFFramePortrait:ApplyMixin(BUFFocusPortrait)

---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.portrait = BUFFocusPortrait.dbDefaults

ns.options.args.focus.args.portrait = BUFFocusPortrait.optionsTable

function BUFFocusPortrait:RefreshConfig()
	if not self.initialized then
		BUFFocus.FrameInit(self)

		self.texture = BUFFocus.container.Portrait
		self.maskTexture = BUFFocus.container.PortraitMask
	end
	self:RefreshPortraitConfig()
end

BUFFocus.Portrait = BUFFocusPortrait
