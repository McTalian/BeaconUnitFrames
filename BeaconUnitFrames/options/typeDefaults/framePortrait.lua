---@class BUFNamespace
local ns = select(2, ...)

---@class BUFFramePortrait: BUFTexture, BoxMaskable
---@field ShowHidePortrait fun(self: BUFFramePortrait)
---@field maskTexture MaskTexture
local FramePortrait = {}

function FramePortrait:ApplyMixin(handler)
	ns.BUFTexture:ApplyMixin(handler, true)
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
		set = "SetEnabled",
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
	self:_SetPortraitSize(self.texture, self.maskTexture)
end

function FramePortrait:_SetPortraitSize(texture, maskTexture)
	self:_SetSize(texture)
	self:_RefreshMask(maskTexture)
end

function FramePortrait:SetScaleFactor()
	self:_SetPortraitScaleFactor(self.texture, self.maskTexture)
end

function FramePortrait:_SetPortraitScaleFactor(texture, maskTexture)
	self:_SetScaleFactor(texture)
	self:_RefreshMask(maskTexture)
end

function FramePortrait:SetPosition()
	self:_SetPortraitPosition(self.texture, self.maskTexture)
end

function FramePortrait:_SetPortraitPosition(texture, maskTexture)
	self:_SetPosition(texture)
	maskTexture:ClearAllPoints()
	maskTexture:SetPoint("CENTER", texture, "CENTER")
end

function FramePortrait:ShowHidePortrait()
	self:_ShowHidePortrait(self.texture, self.maskTexture)
end

function FramePortrait:_ShowHidePortrait(texture, maskTexture)
	local show = self:GetEnabled()
	if show then
		if self.module:IsHooked(texture, "Show") then
			self.module:Unhook(texture, "Show")
		end
		if self.module:IsHooked(maskTexture, "Show") then
			self.module:Unhook(maskTexture, "Show")
		end
		texture:Show()
		maskTexture:Show()
	else
		texture:Hide()
		maskTexture:Hide()
		if not self.module:IsHooked(texture, "Show") then
			self.module:SecureHook(texture, "Show", function(s)
				s:Hide()
			end)
		end
		if not self.module:IsHooked(maskTexture, "Show") then
			self.module:SecureHook(maskTexture, "Show", function(s)
				s:Hide()
			end)
		end
	end
end

function FramePortrait:RefreshMask()
	self:_RefreshMask(self.maskTexture)
end

function FramePortrait:_RefreshMask(maskTexture)
	self:__RefreshMask(maskTexture)
	local width, height, scale = self:GetWidth(), self:GetHeight(), self:GetScale()
	local widthScale = self:GetMaskWidthScale() or 1
	local heightScale = self:GetMaskHeightScale() or 1
	maskTexture:SetSize(width * widthScale, height * heightScale)
	maskTexture:SetScale(scale)
end

ns.BUFFramePortrait = FramePortrait
