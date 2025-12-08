---@class BUFNamespace
local ns = select(2, ...)

---@class BUFToFocus
local BUFToFocus = ns.BUFToFocus

---@class BUFToFocus.Buffs: Positionable
local BUFToFocusBuffs = {
	configPath = "unitFrames.tofocus.buffs",
}

BUFToFocusBuffs.optionsTable = {
	type = "group",
	handler = BUFToFocusBuffs,
	name = ns.L["Buffs"],
	order = BUFToFocus.optionsOrder.BUFFS,
	args = {},
}

---@class BUFDbSchema.UF.ToFocus.Buffs
BUFToFocusBuffs.dbDefaults = {
	anchorPoint = "TOPLEFT",
	relativeTo = BUFToFocus.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = 4,
	yOffset = -10,
}

ns.Mixin(BUFToFocusBuffs, ns.Positionable)
---@class BUFDbSchema.UF.ToFocus
ns.dbDefaults.profile.unitFrames.tofocus = ns.dbDefaults.profile.unitFrames.tofocus
ns.dbDefaults.profile.unitFrames.tofocus.buffs = BUFToFocusBuffs.dbDefaults

ns.AddPositionableOptions(BUFToFocusBuffs.optionsTable.args)

ns.options.args.tofocus.args.buffs = BUFToFocusBuffs.optionsTable

function BUFToFocusBuffs:RefreshConfig()
	if self:DbGet("enableFrameTexture") then
		return
	end

	if not self.initialized then
		BUFToFocus.FrameInit(self)
	end

	self:SetPosition()
end

function BUFToFocusBuffs:SetPosition()
	self.texture = FocusFrameToTDebuff1
	self:_SetPosition(self.texture)
end

BUFToFocus.Buffs = BUFToFocusBuffs
