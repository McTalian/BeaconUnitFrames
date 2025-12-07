---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Buffs: Positionable
local BUFTargetBuffs = {
	configPath = "unitFrames.target.buffs",
}

BUFTargetBuffs.optionsTable = {
	type = "group",
	handler = BUFTargetBuffs,
	name = ns.L["Buffs"],
	order = BUFTarget.optionsOrder.BUFFS,
	args = {},
}

---@class BUFDbSchema.UF.Target.Buffs
BUFTargetBuffs.dbDefaults = {
	anchorPoint = "CENTER",
	relativeTo = BUFTarget.relativeToFrames.FRAME,
	relativePoint = "CENTER",
	xOffset = 0,
	yOffset = 0,
}

ns.Mixin(BUFTargetBuffs, ns.Positionable)
---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.buffs = BUFTargetBuffs.dbDefaults

ns.AddPositionableOptions(BUFTargetBuffs.optionsTable.args)

ns.options.args.target.args.buffs = BUFTargetBuffs.optionsTable

function BUFTargetBuffs:RefreshConfig()
	if self:DbGet("enableFrameTexture") then
		return
	end

	if not self.initialized then
		BUFTarget.FrameInit(self)
	end

	self:SetPosition()
end

function BUFTargetBuffs:SetPosition()
	self.texture = TargetFrame.TargetFrameContainer.FrameTexture
	self:_SetPosition(self.texture)
end

BUFTarget.Buffs = BUFTargetBuffs
