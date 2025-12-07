---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Portrait: BUFTexture, BoxMaskable
local BUFTargetPortrait = {
	configPath = "unitFrames.target.portrait",
	frameKey = BUFTarget.relativeToFrames.PORTRAIT,
}

BUFTargetPortrait.optionsTable = {
	type = "group",
	handler = BUFTargetPortrait,
	name = ns.L["Portrait"],
	order = BUFTarget.optionsOrder.PORTRAIT,
	args = {
		enabled = {
			type = "toggle",
			name = ENABLE,
			desc = ns.L["EnablePlayerPortrait"],
			set = function(info, value)
				ns.db.profile.unitFrames.target.portrait.enabled = value
				BUFTargetPortrait:ShowHidePortrait()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.target.portrait.enabled
			end,
			order = ns.defaultOrderMap.ENABLE,
		},
	},
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

BUFTargetPortrait.noAtlas = true

ns.BUFTexture:ApplyMixin(BUFTargetPortrait)
ns.Mixin(BUFTargetPortrait, ns.BoxMaskable)

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
	self:ShowHidePortrait()
	self:SetPosition()
	self:SetSize()
	self:RefreshMask()
end

function BUFTargetPortrait:SetSize()
	self:_SetSize(self.texture)
	self:RefreshMask()
end

function BUFTargetPortrait:SetPosition()
	self:_SetPosition(self.texture)
	self.maskTexture:ClearAllPoints()
	self.maskTexture:SetPoint("CENTER", self.texture, "CENTER")
end

function BUFTargetPortrait:ShowHidePortrait()
	local show = self:DbGet("enabled")
	if show then
		if BUFTarget:IsHooked(self.texture, "Show") then
			BUFTarget:Unhook(self.texture, "Show")
		end
		if BUFTarget:IsHooked(self.maskTexture, "Show") then
			BUFTarget:Unhook(self.maskTexture, "Show")
		end
		self.texture:Show()
		self.maskTexture:Show()
	else
		self.texture:Hide()
		self.maskTexture:Hide()
		if not ns.BUFTarget:IsHooked(self.texture, "Show") then
			BUFTarget:SecureHook(self.texture, "Show", function(s)
				s:Hide()
			end)
		end
		if not ns.BUFTarget:IsHooked(self.maskTexture, "Show") then
			BUFTarget:SecureHook(self.maskTexture, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFTargetPortrait:RefreshMask()
	self:_RefreshMask(self.maskTexture)
	local width, height = self:GetWidth(), self:GetHeight()
	local widthScale = self:GetMaskWidthScale() or 1
	local heightScale = self:GetMaskHeightScale() or 1
	self.maskTexture:SetSize(width * widthScale, height * heightScale)
end

BUFTarget.Portrait = BUFTargetPortrait
