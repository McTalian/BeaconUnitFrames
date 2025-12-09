---@class BUFNamespace
local ns = select(2, ...)

--- Add status bar foreground options to the given options table
--- @param optionsTable table
--- @param _orderMap? BUFOptionsOrder
function ns.AddStatusBarBackgroundOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap
	ns.AddColorOptions(optionsTable, orderMap, true)
	ns.AddBackgroundTextureOptions(optionsTable, orderMap)
end

---@class StatusBarBackgroundHandler
---@field background Texture
---@field RefreshColor fun(self: StatusBarBackground)
---@field RefreshBackgroundTexture fun(self: StatusBarBackground)
---@field RestoreDefaultBackgroundTexture fun(self: StatusBarBackground)

---@class StatusBarBackground: StatusBarBackgroundHandler, Colorable, BackgroundTexturable
local StatusBarBackground = {}

--- Apply mixins to a StatusBarBackground
--- @param self StatusBarBackground
--- @param handler BUFConfigHandler
function StatusBarBackground:ApplyMixin(handler)
	ns.Mixin(handler, ns.Colorable, ns.BackgroundTexturable)
	ns.Mixin(handler, self)

	if handler.optionsTable then
		ns.AddStatusBarBackgroundOptions(handler.optionsTable.args, handler.optionsOrder)
	end
end

function StatusBarBackground:RefreshStatusBarBackgroundConfig()
	self:RefreshBackgroundTexture()
	self:RefreshColor()
end

function StatusBarBackground:RefreshBackgroundTexture()
	self:_RefreshBackgroundTexture(self.background)
end

function StatusBarBackground:_RefreshBackgroundTexture(background)
	local useCustomTexture = self:GetUseBackgroundTexture()
	if useCustomTexture then
		local textureName = self:GetBackgroundTexture() or "Blizzard"
		local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, textureName)
		if not texturePath then
			texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
		end
		background:SetTexture(texturePath)
		background:Show()
	else
		self:RestoreDefaultBackgroundTexture()
	end
end

function StatusBarBackground:RefreshColor()
	self:_RefreshColor(self.background)
end

function StatusBarBackground:_RefreshColor(background)
	local r, g, b, a = self:GetCustomColor()
	background:SetVertexColor(r, g, b, a)
end

ns.StatusBarBackground = StatusBarBackground
