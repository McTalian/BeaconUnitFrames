---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.ClassResources: Positionable, Scalable
local BUFPlayerClassResources = {
	configPath = "unitFrames.player.classResources",
}

BUFPlayerClassResources.optionsTable = {
	type = "group",
	handler = BUFPlayerClassResources,
	name = ns.L["ClassResources"],
	order = BUFPlayer.optionsOrder.CLASS_RESOURCES,
	args = {},
}

---@class BUFDbSchema.UF.Player.ClassResources
BUFPlayerClassResources.dbDefaults = {
	scale = 1.0,
	anchorPoint = "TOP",
	relativeTo = BUFPlayer.relativeToFrames.FRAME,
	relativePoint = "BOTTOM",
	xOffset = 30,
	yOffset = 25,
}

ns.Mixin(BUFPlayerClassResources, ns.Positionable, ns.Scalable)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
ns.dbDefaults.profile.unitFrames.player.classResources = BUFPlayerClassResources.dbDefaults

ns.AddPositionableOptions(BUFPlayerClassResources.optionsTable.args)
ns.AddScalableOptions(BUFPlayerClassResources.optionsTable.args)
ns.options.args.player.args.classResources = BUFPlayerClassResources.optionsTable

function BUFPlayerClassResources:RefreshConfig()
	if not self.initialized then
		BUFPlayer.FrameInit(self)

		self.frame = PlayerFrameBottomManagedFramesContainer
	end
	self:SetPosition()
	self:SetScaleFactor()
end

function BUFPlayerClassResources:SetPosition()
	self:_SetPosition(self.frame)
end

function BUFPlayerClassResources:SetScaleFactor()
	self:_SetScaleFactor(self.frame)
end

BUFPlayer.ClassResources = BUFPlayerClassResources
