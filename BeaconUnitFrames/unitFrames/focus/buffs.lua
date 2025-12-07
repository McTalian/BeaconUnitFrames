---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFocus
local BUFFocus = ns.BUFFocus

---@class BUFFocus.Buffs: Positionable
local BUFFocusBuffs = {
	configPath = "unitFrames.focus.buffs",
}

BUFFocusBuffs.optionsTable = {
	type = "group",
	handler = BUFFocusBuffs,
	name = ns.L["Buffs"],
	order = BUFFocus.optionsOrder.BUFFS,
	args = {},
}

---@class BUFDbSchema.UF.Focus.Buffs
BUFFocusBuffs.dbDefaults = {
	anchorPoint = "CENTER",
	relativeTo = BUFFocus.relativeToFrames.FRAME,
	relativePoint = "CENTER",
	xOffset = 0,
	yOffset = 0,
}

ns.Mixin(BUFFocusBuffs, ns.Positionable)
---@class BUFDbSchema.UF.Focus
ns.dbDefaults.profile.unitFrames.focus = ns.dbDefaults.profile.unitFrames.focus
ns.dbDefaults.profile.unitFrames.focus.buffs = BUFFocusBuffs.dbDefaults

ns.AddPositionableOptions(BUFFocusBuffs.optionsTable.args)

ns.options.args.focus.args.buffs = BUFFocusBuffs.optionsTable

function BUFFocusBuffs:RefreshConfig()
	if self:DbGet("enableFrameTexture") then
		return
	end

	if not self.initialized then
		BUFFocus.FrameInit(self)
	end

	self:SetPosition()
end

function BUFFocusBuffs:SetPosition()
	self.texture = FocusFrame.TargetFrameContainer.FrameTexture
	self:_SetPosition(self.texture)
end

BUFFocus.Buffs = BUFFocusBuffs
