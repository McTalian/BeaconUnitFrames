---@class BUFNamespace
local ns = select(2, ...)

--- Add status bar texture options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddStatusBarTextureOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap

	optionsTable.statusBarHeader = optionsTable.statusBarHeader
		or {
			type = "header",
			name = ns.L["Status Bar Options"],
			order = orderMap.STATUS_BAR_HEADER,
		}

	optionsTable.useStatusBarTexture = {
		type = "toggle",
		name = ns.L["Use Status Bar Texture"],
		desc = ns.L["UseStatusBarTextureDesc"],
		set = "SetUseStatusBarTexture",
		get = "GetUseStatusBarTexture",
		order = orderMap.USE_STATUS_BAR_TEXTURE,
	}

	optionsTable.statusBarTexture = {
		type = "select",
		name = ns.L["Status Bar Texture"],
		dialogControl = "LSM30_Statusbar",
		values = function()
			return ns.lsm:HashTable(ns.lsm.MediaType.STATUSBAR)
		end,
		disabled = "IsStatusBarTextureDisabled",
		set = "SetStatusBarTexture",
		get = "GetStatusBarTexture",
		order = orderMap.STATUS_BAR_TEXTURE,
	}
end

---@class StatusBarTexturableHandler: MixinBase
---@field RefreshStatusBarTexture fun(self: StatusBarTexturableHandler)

---@class StatusBarTexturable: StatusBarTexturableHandler
local StatusBarTexturable = {}

ns.Mixin(StatusBarTexturable, ns.MixinBase)

---Set whether to use a custom status bar texture
---@param info table AceConfig info table
---@param value boolean Whether to use custom texture
function StatusBarTexturable:SetUseStatusBarTexture(info, value)
	self:DbSet("useStatusBarTexture", value)
	self:RefreshStatusBarTexture()
end

---Get whether to use a custom status bar texture
---@param info? table AceConfig info table
---@return boolean|nil Whether to use custom texture
function StatusBarTexturable:GetUseStatusBarTexture(info)
	return self:DbGet("useStatusBarTexture")
end

---Set the status bar texture
---@param info table AceConfig info table
---@param value string The texture name
function StatusBarTexturable:SetStatusBarTexture(info, value)
	self:DbSet("statusBarTexture", value)
	self:RefreshStatusBarTexture()
end

---Get the status bar texture
---@param info? table AceConfig info table
---@return string|nil The texture name
function StatusBarTexturable:GetStatusBarTexture(info)
	return self:DbGet("statusBarTexture")
end

---Check if status bar texture selection is disabled
---@param info table AceConfig info table
---@return boolean Whether texture selection is disabled
function StatusBarTexturable:IsStatusBarTextureDisabled(info)
	return self:DbGet("useStatusBarTexture") == false
end

ns.StatusBarTexturable = StatusBarTexturable
