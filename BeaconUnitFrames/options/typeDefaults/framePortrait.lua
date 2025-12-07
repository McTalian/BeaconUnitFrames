---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFramePortrait: BUFTexture, BoxMaskable
---@field ShowHidePortrait fun(self: BUFFramePortrait)
---@field maskTexture MaskTexture
local FramePortrait = {}

function FramePortrait:ApplyMixin(handler)
	ns.BUFTexture:ApplyMixin(handler)
	ns.Mixin(handler, ns.BoxMaskable, self)

	if handler.optionsTable then
		self:AddFramePortraitOptions(handler.optionsTable.args, handler.optionsOrder)
	end
end

function FramePortrait:AddFramePortraitOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap
	ns.AddBoxMaskableOptions(optionsTable, orderMap)
	ns.AddTextureOptions(optionsTable, orderMap, true)

	optionsTable.enabled = {
		type = "toggle",
		name = ENABLE,
		desc = ns.L["EnableFramePortrait"],
		set = "SetEnable",
		get = "GetEnabled",
		order = orderMap.ENABLE,
	}
end

function FramePortrait:SetEnabled(info, value)
	self:DbSet("enabled", value)
	self:ShowHidePortrait()
end

function FramePortrait:GetEnabled(info)
	return self:DbGet("enabled")
end

function FramePortrait:RefreshPortraitConfig()
	self:ShowHidePortrait()
	self:RefreshTextureConfig()
	self:RefreshMask()
end

function FramePortrait:SetSize()
	self:_SetSize(self.texture)
	self:RefreshMask()
end

function FramePortrait:SetScaleFactor()
	self:_SetScaleFactor(self.texture)
	self:RefreshMask()
end

function FramePortrait:SetPosition()
	self:_SetPosition(self.texture)
	self.maskTexture:ClearAllPoints()
	self.maskTexture:SetPoint("CENTER", self.texture, "CENTER")
end

function FramePortrait:ShowHidePortrait()
	local show = self:GetEnabled()
	if show then
		if self.module:IsHooked(self.texture, "Show") then
			self.module:Unhook(self.texture, "Show")
		end
		if self.module:IsHooked(self.maskTexture, "Show") then
			self.module:Unhook(self.maskTexture, "Show")
		end
		self.texture:Show()
		self.maskTexture:Show()
	else
		self.texture:Hide()
		self.maskTexture:Hide()
		if not self.module:IsHooked(self.texture, "Show") then
			self.module:SecureHook(self.texture, "Show", function(s)
				s:Hide()
			end)
		end
		if not self.module:IsHooked(self.maskTexture, "Show") then
			self.module:SecureHook(self.maskTexture, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function FramePortrait:RefreshMask()
	self:_RefreshMask(self.maskTexture)
	local width, height, scale = self:GetWidth(), self:GetHeight(), self:GetScale()
	local widthScale = self:GetMaskWidthScale() or 1
	local heightScale = self:GetMaskHeightScale() or 1
	self.maskTexture:SetSize(width * widthScale, height * heightScale)
	self.maskTexture:SetScale(scale)
end

ns.BUFFramePortrait = FramePortrait
