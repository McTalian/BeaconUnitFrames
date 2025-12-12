---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Portrait: BUFFramePortrait
local BUFBossPortrait = {
	configPath = "unitFrames.boss.portrait",
	frameKey = BUFBoss.relativeToFrames.PORTRAIT,
	module = BUFBoss,
}

BUFBossPortrait.optionsTable = {
	type = "group",
	handler = BUFBossPortrait,
	name = ns.L["Portrait"],
	order = BUFBoss.optionsOrder.PORTRAIT,
	args = {},
}

---@class BUFDbSchema.UF.Boss.Portrait
BUFBossPortrait.dbDefaults = {
	enabled = false,
	width = 58,
	height = 58,
	scale = 1.0,
	anchorPoint = "TOPRIGHT",
	relativeTo = BUFBoss.relativeToFrames.FRAME,
	relativePoint = "TOPRIGHT",
	xOffset = -26,
	yOffset = -19,
	mask = "interface/hud/uiunitframeplayerportraitmask.blp",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

ns.BUFFramePortrait:ApplyMixin(BUFBossPortrait)
ns.Mixin(BUFBossPortrait, ns.BUFBossPositionable)

---@class BUFDbSchema.UF.Boss
ns.dbDefaults.profile.unitFrames.boss = ns.dbDefaults.profile.unitFrames.boss
ns.dbDefaults.profile.unitFrames.boss.portrait = BUFBossPortrait.dbDefaults

ns.options.args.boss.args.portrait = BUFBossPortrait.optionsTable

function BUFBossPortrait:RefreshConfig()
	if not self.initialized then
		BUFBoss.FrameInit(self)

		for _, bbi in ipairs(BUFBoss.frames) do
			bbi.portrait = {}
			bbi.portrait.texture = bbi.container.Portrait
			bbi.portrait.texture.bufOverrideParentFrame = bbi.frame
			bbi.portrait.maskTexture = bbi.container.PortraitMask
		end
	end

	self:RefreshPortraitConfig()
end

function BUFBossPortrait:ToggleDemoMode()
	self.demoMode = not self.demoMode
	for _, bbi in ipairs(BUFBoss.frames) do
		if self.demoMode then
			bbi.portrait.texture:Show()
			bbi.portrait.maskTexture:Show()
			SetPortraitTexture(bbi.portrait.texture, "player")
		else
			bbi.portrait.texture:Hide()
			bbi.portrait.maskTexture:Hide()
		end
	end
end

function BUFBossPortrait:ShowHidePortrait()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_ShowHidePortrait(bbi.portrait.texture, bbi.portrait.maskTexture)
		bbi.frame.showPortrait = self:GetEnabled()
	end
end

function BUFBossPortrait:SetSize()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPortraitSize(bbi.portrait.texture, bbi.portrait.maskTexture)
	end
end

function BUFBossPortrait:SetPosition()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPortraitPosition(bbi.portrait.texture, bbi.portrait.maskTexture)
	end
end

function BUFBossPortrait:SetScaleFactor()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_SetPortraitScaleFactor(bbi.portrait.texture, bbi.portrait.maskTexture)
	end
end

function BUFBossPortrait:RefreshMask()
	for _, bbi in ipairs(BUFBoss.frames) do
		self:_RefreshMask(bbi.portrait.maskTexture)
	end
end

BUFBoss.Portrait = BUFBossPortrait
