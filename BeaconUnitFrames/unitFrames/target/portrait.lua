---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Portrait: BUFFramePortrait
local BUFTargetPortrait = {
	configPath = "unitFrames.target.portrait",
	frameKey = BUFTarget.relativeToFrames.PORTRAIT,
	module = BUFTarget,
}

BUFTargetPortrait.optionsTable = {
	type = "group",
	handler = BUFTargetPortrait,
	name = ns.L["Portrait"],
	order = BUFTarget.optionsOrder.PORTRAIT,
	args = {},
}

---@class BUFDbSchema.UF.Target.Portrait
BUFTargetPortrait.dbDefaults = {
	enabled = true,
	width = 58,
	height = 58,
	scale = 1.0,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFTarget.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -26,
	yOffset = -19,
	mask = "interface/hud/uiunitframeplayerportraitmask.blp",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

ns.BUFFramePortrait:ApplyMixin(BUFTargetPortrait)

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.portrait = BUFTargetPortrait.dbDefaults

ns.options.args.target.args.portrait = BUFTargetPortrait.optionsTable

function BUFTargetPortrait:RefreshConfig()
	if not self.initialized then
		BUFTarget.FrameInit(self)

		self.texture = BUFTarget.container.Portrait
		self.maskTexture = BUFTarget.container.PortraitMask
	end
	self:RefreshPortraitConfig()
end

BUFTarget.Portrait = BUFTargetPortrait
