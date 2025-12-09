---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.ReputationBar: BUFTexture, Colorable, ReactionColorable, ClassColorable
local BUFBossReputationBar = {
	configPath = "unitFrames.boss.reputationBar",
	frameKey = BUFBoss.relativeToFrames.REPUTATION_BAR,
}

BUFBossReputationBar.optionsTable = {
	type = "group",
	name = ns.L["Reputation Bar"],
	handler = BUFBossReputationBar,
	order = BUFBoss.optionsOrder.REPUTATION_BAR,
	args = {
		texturing = {
			type = "header",
			name = ns.L["Texturing"],
			order = ns.defaultOrderMap.TEXTURING_HEADER,
		},
		atlasTexture = {
			type = "select",
			name = ns.L["Atlas Texture"],
			desc = ns.L["AtlasTextureDesc"],
			order = ns.defaultOrderMap.ATLAS_TEXTURE,
			values = {
				["UI-HUD-UnitFrame-Target-PortraitOn-Type"] = "Default",
				["_ItemUpgradeTooltip-NineSlice-EdgeBottom"] = "Bottom Glow",
				["Interface/AddOns/BeaconUnitFrames/icons/underhighlight_mask.png"] = "Custom Bottom Glow",
			},
			set = "SetAtlasTexture",
			get = "GetAtlasTexture",
		},
	},
}

---@class BUFDbSchema.UF.Boss.ReputationBar
BUFBossReputationBar.dbDefaults = {
	width = 134,
	height = 10,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFBoss.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -75,
	yOffset = -25,
	atlasTexture = "UI-HUD-UnitFrame-Target-PortraitOn-Type",
	useCustomColor = false,
	customColor = { 0.8, 0.8, 0.2, 1 },
	useReactionColor = true,
	useClassColor = false,
}

ns.BUFTexture:ApplyMixin(BUFBossReputationBar)
ns.Mixin(BUFBossReputationBar, ns.Colorable, ns.ClassColorable, ns.ReactionColorable, ns.BUFBossPositionable)

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss
ns.dbDefaults.profile.unitFrames.boss.reputationBar = BUFBossReputationBar.dbDefaults

ns.AddColorOptions(BUFBossReputationBar.optionsTable.args)
ns.AddClassColorOptions(BUFBossReputationBar.optionsTable.args)
ns.AddReactionColorOptions(BUFBossReputationBar.optionsTable.args)

ns.options.args.boss.args.reputationBar = BUFBossReputationBar.optionsTable

function BUFBossReputationBar:SetAtlasTexture(info, value)
	self:DbSet("atlasTexture", value)
	self:SetTexture()
end

function BUFBossReputationBar:GetAtlasTexture(info)
	return self:DbGet("atlasTexture")
end

function BUFBossReputationBar:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.reputationBar = {}
			bbi.reputationBar.texture = bbi.contentMain.ReputationColor
			bbi.reputationBar.texture.bufOverrideParentFrame = bbi.frame

			if not BUFBoss:IsHooked(bbi.frame, "CheckFaction") then
				BUFBoss:SecureHook(bbi.frame, "CheckFaction", function()
					self:_RefreshColor(bbi.reputationBar.texture)
				end)
			end
		end
	end
	self:SetSize()
	self:SetPosition()
	self:SetTexture()
	self:RefreshColor()
end

function BUFBossReputationBar:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetSize(bbi.reputationBar.texture)
	end
end

function BUFBossReputationBar:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPosition(bbi.reputationBar.texture)
	end
end

function BUFBossReputationBar:SetTexture()
	local atlasTexture = self:DbGet("atlasTexture")
	local sPos, ePos = string.find(atlasTexture, "%.")
	if not sPos then
		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.reputationBar.texture:SetAtlas(atlasTexture, false)
		end
	else
		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.reputationBar.texture:SetTexture(atlasTexture)
		end
	end
end

function BUFBossReputationBar:RefreshColor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshColor(bbi.reputationBar.texture)
	end
end

function BUFBossReputationBar:_RefreshColor(texture)
	local useCustomColor = self:DbGet("useCustomColor")
	local useClassColor = self:DbGet("useClassColor")
	local useReactionColor = self:DbGet("useReactionColor")

	local r, g, b, a = nil, nil, nil, 1
	if useCustomColor then
		r, g, b, a = unpack(self:DbGet("customColor"))
	elseif useClassColor and (not useReactionColor or UnitPlayerControlled("target")) then
		local _, class = UnitClass("target")
		r, g, b = GetClassColor(class)
	elseif useReactionColor then
		r, g, b = GameTooltip_UnitColor("target")
	else
		return
	end

	texture:SetVertexColor(r, g, b, a)
end

BUFBoss.ReputationBar = BUFBossReputationBar
