---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Indicators
local BUFPartyIndicators = ns.BUFParty.Indicators

---@class BUFParty.Indicators.RoleIcon: BUFScaleTexture
local BUFPartyRoleIcon = {
	configPath = "unitFrames.party.roleIcon",
}

BUFPartyRoleIcon.optionsTable = {
	type = "group",
	handler = BUFPartyRoleIcon,
	name = ns.L["Role Icon"],
	order = BUFPartyIndicators.optionsOrder.ROLE_ICON,
	args = {},
}

---@class BUFDbSchema.UF.Party.RoleIcon
BUFPartyRoleIcon.dbDefaults = {
	scale = 1,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFParty.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -5,
	yOffset = -5,
}

ns.BUFScaleTexture:ApplyMixin(BUFPartyRoleIcon)
ns.Mixin(BUFPartyRoleIcon, ns.BUFPartyPositionable)

ns.options.args.party.args.indicators.args.roleIcon = BUFPartyRoleIcon.optionsTable

---@class BUFDbSchema.UF.Party
ns.dbDefaults.profile.unitFrames.party = ns.dbDefaults.profile.unitFrames.party
ns.dbDefaults.profile.unitFrames.party.roleIcon = BUFPartyRoleIcon.dbDefaults

function BUFPartyRoleIcon:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bbi in ipairs(BUFParty.frames) do
		if self.demoMode then
			bbi.indicators.roleIcon.texture:Show()
		else
			bbi.indicators.roleIcon.texture:Hide()
		end
	end
end

function BUFPartyRoleIcon:RefreshConfig()
	if not self.initialized then
		BUFParty.FrameInit(self)

		for _, bbi in ipairs(BUFParty.frames) do
			bbi.indicators.roleIcon = {}
			bbi.indicators.roleIcon.texture = bbi.frame.PartyMemberOverlay.RoleIcon
			bbi.indicators.roleIcon.texture.bufOverrideParentFrame = bbi.frame
		end
	end

	self:RefreshScaleTextureConfig()
end

function BUFPartyRoleIcon:SetPosition()
	for _, bbi in ipairs(BUFParty.frames) do
		self:_SetPosition(bbi.indicators.roleIcon.texture)
	end
end

function BUFPartyRoleIcon:SetScaleFactor()
	for _, bbi in ipairs(BUFParty.frames) do
		self:_SetScaleFactor(bbi.indicators.roleIcon.texture)
	end
end

BUFPartyIndicators.RoleIcon = BUFPartyRoleIcon
