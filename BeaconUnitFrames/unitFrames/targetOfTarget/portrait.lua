---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Portrait: BUFFramePortrait
local BUFToTPortrait = {
	configPath = "unitFrames.tot.portrait",
	frameKey = BUFToT.relativeToFrames.PORTRAIT,
	module = BUFToT,
}

BUFToTPortrait.optionsTable = {
	type = "group",
	handler = BUFToTPortrait,
	name = ns.L["Portrait"],
	order = BUFToT.optionsOrder.PORTRAIT,
	args = {},
}

---@class BUFDbSchema.UF.ToT.Portrait
BUFToTPortrait.dbDefaults = {
	enabled = true,
	width = 37,
	height = 37,
	scale = 1.0,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFToT.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 5,
	yOffset = -5,
	mask = "interface/hud/uiunitframeplayerportraitmask.blp",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

ns.BUFFramePortrait:ApplyMixin(BUFToTPortrait)

---@class BUFDbSchema.UF.ToT
ns.dbDefaults.profile.unitFrames.tot = ns.dbDefaults.profile.unitFrames.tot
ns.dbDefaults.profile.unitFrames.tot.portrait = BUFToTPortrait.dbDefaults

ns.options.args.tot.args.portrait = BUFToTPortrait.optionsTable

function BUFToTPortrait:RefreshConfig()
	if not self.initialized then
		BUFToT.FrameInit(self)

		self.texture = BUFToT.frame.Portrait
		self.maskTexture = BUFToT.frame.PortraitMask
	end
	self:RefreshPortraitConfig()
end

BUFToT.Portrait = BUFToTPortrait
