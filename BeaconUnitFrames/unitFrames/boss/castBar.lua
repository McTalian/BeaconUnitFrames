---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.CastBar: Positionable
local CastBar = {
	configPath = "unitFrames.boss.castBar",
}

CastBar.optionsTable = {
	type = "group",
	handler = CastBar,
	name = ns.L["CastBar"],
	order = BUFBoss.optionsOrder.SPELL,
	args = {},
}

---@class BUFDbSchema.UF.Boss.CastBar
CastBar.dbDefaults = {
	enabled = true,
	scale = 1.0,
	width = 120,
	height = 10,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFBoss.relativeToFrames.FRAME,
	relativePoint = "BOTTOMRIGHT",
	xOffset = -105,
	yOffset = 15,
}

ns.Mixin(CastBar, ns.Positionable, ns.BUFBossPositionable)
ns.AddPositionableOptions(CastBar.optionsTable.args)

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss
ns.dbDefaults.profile.unitFrames.boss.castBar = CastBar.dbDefaults

ns.options.args.boss.args.castBar = CastBar.optionsTable

function CastBar:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.castBar = {}
			bbi.castBar.statusBar = bbi.frame.spellbar
			bbi.castBar.statusBar.bufOverrideParentFrame = bbi.frame
		end
	end

	self:SetPosition()
end

function CastBar:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.castBar.statusBar)
	end
end

BUFBoss.CastBar = CastBar
