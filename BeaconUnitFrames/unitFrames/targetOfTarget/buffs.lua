---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToT
local BUFToT = ns.BUFToT

---@class BUFToT.Buffs: Positionable
local BUFToTBuffs = {
	configPath = "unitFrames.tot.buffs",
}

BUFToTBuffs.optionsTable = {
	type = "group",
	handler = BUFToTBuffs,
	name = ns.L["Buffs"],
	order = BUFToT.optionsOrder.BUFFS,
	args = {},
}

---@class BUFDbSchema.UF.ToT.Buffs
BUFToTBuffs.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFToT.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = 4,
	yOffset = -10,
}

ns.Mixin(BUFToTBuffs, ns.Positionable)
---@class BUFDbSchema.UF.ToT
ns.dbDefaults.profile.unitFrames.tot = ns.dbDefaults.profile.unitFrames.tot
ns.dbDefaults.profile.unitFrames.tot.buffs = BUFToTBuffs.dbDefaults

ns.AddPositionableOptions(BUFToTBuffs.optionsTable.args)

ns.options.args.tot.args.buffs = BUFToTBuffs.optionsTable

function BUFToTBuffs:RefreshConfig()
	if self:DbGet("enableFrameTexture") then
		return
	end

	if not self.initialized then
		BUFToT.FrameInit(self)
	end

	self:SetPosition()
end

function BUFToTBuffs:SetPosition()
	self.texture = TargetFrameToTDebuff1
	self:_SetPosition(self.texture)
end

BUFToT.Buffs = BUFToTBuffs
