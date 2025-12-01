---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Portrait: Sizable, Positionable, BoxMaskable
local BUFTargetPortrait = {
	configPath = "unitFrames.target.portrait",
}

ns.Mixin(BUFTargetPortrait, ns.Sizable, ns.Positionable, ns.BoxMaskable)

BUFTarget.Portrait = BUFTargetPortrait

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.Portrait
ns.dbDefaults.profile.unitFrames.target.portrait = {
	enabled = true,
	width = 58,
	height = 58,
	anchorPoint = "TOPRIGHT",
	relativeTo = ns.DEFAULT,
	relativePoint = "TOPRIGHT",
	xOffset = -26,
	yOffset = -19,
	mask = "interface/hud/uiunitframeplayerportraitmask.blp",
	maskWidthScale = 1,
	maskHeightScale = 1,
	alpha = 1.0,
}

local portrait = {
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

ns.AddSizableOptions(portrait.args)
ns.AddPositionableOptions(portrait.args)
ns.AddBoxMaskableOptions(portrait.args)

ns.options.args.target.args.portrait = portrait

function BUFTargetPortrait:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.defaultRelativeTo = BUFTarget.container
	end
	self:ShowHidePortrait()
	self:SetPosition()
	self:SetSize()
	self:RefreshMask()
end

function BUFTargetPortrait:SetSize()
	self:_SetSize(BUFTarget.container.Portrait)
	self:RefreshMask()
end

function BUFTargetPortrait:SetPosition()
	self:_SetPosition(BUFTarget.container.Portrait)
end

function BUFTargetPortrait:ShowHidePortrait()
	local parent = BUFTarget
	local container = parent.container
	local show = ns.db.profile.unitFrames.target.portrait.enabled
	if show then
		if parent:IsHooked(container.Portrait, "Show") then
			parent:Unhook(container.Portrait, "Show")
		end
		if parent:IsHooked(container.PortraitMask, "Show") then
			parent:Unhook(container.PortraitMask, "Show")
		end
		container.Portrait:Show()
		container.PortraitMask:Show()
	else
		container.Portrait:Hide()
		container.PortraitMask:Hide()
		if not ns.BUFTarget:IsHooked(container.Portrait, "Show") then
			parent:SecureHook(container.Portrait, "Show", function(s)
				s:Hide()
			end)
		end
		if not ns.BUFTarget:IsHooked(container.PortraitMask, "Show") then
			parent:SecureHook(container.PortraitMask, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function BUFTargetPortrait:RefreshMask()
	local mask = BUFTarget.container.PortraitMask
	self:_RefreshMask(mask)
	mask:ClearAllPoints()
	mask:SetPoint("CENTER", BUFTarget.container.Portrait, "CENTER")
	local width = self:GetWidth()
	local height = self:GetHeight()
	local widthScale = self:GetMaskWidthScale() or 1
	local heightScale = self:GetMaskHeightScale() or 1
	mask:SetSize(width * widthScale, height * heightScale)
end
