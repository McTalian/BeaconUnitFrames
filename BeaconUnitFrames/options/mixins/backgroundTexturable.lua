---@class BUFNamespace
local ns = select(2, ...)

--- Add background texture options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddBackgroundTextureOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap

	optionsTable.backgroundHeader = optionsTable.backgroundHeader
		or {
			type = "header",
			name = ns.L["Background Options"],
			order = orderMap.BACKGROUND_HEADER,
		}

	optionsTable.useBackgroundTexture = {
		type = "toggle",
		name = ns.L["Use Background Texture"],
		desc = ns.L["UseBackgroundTextureDesc"],
		set = "SetUseBackgroundTexture",
		get = "GetUseBackgroundTexture",
		order = orderMap.USE_BACKGROUND_TEXTURE,
	}

	optionsTable.backgroundTexture = {
		type = "select",
		name = ns.L["Background Texture"],
		dialogControl = "LSM30_Background",
		values = function()
			return ns.lsm:HashTable(ns.lsm.MediaType.BACKGROUND)
		end,
		disabled = "IsBackgroundTextureDisabled",
		set = "SetBackgroundTexture",
		get = "GetBackgroundTexture",
		order = orderMap.BACKGROUND_TEXTURE,
	}
end

---@class BackgroundTexturableHandler: MixinBase
---@field RefreshBackgroundTexture fun(self: BackgroundTexturableHandler)

---@class BackgroundTexturable: BackgroundTexturableHandler
local BackgroundTexturable = {}

ns.Mixin(BackgroundTexturable, ns.MixinBase)

---Set whether to use a custom background texture
---@param info table AceConfig info table
---@param value boolean Whether to use custom texture
function BackgroundTexturable:SetUseBackgroundTexture(info, value)
	self:DbSet("useBackgroundTexture", value)
	self:RefreshBackgroundTexture()
end

---Get whether to use a custom background texture
---@param info table AceConfig info table
---@return boolean|nil Whether to use custom texture
function BackgroundTexturable:GetUseBackgroundTexture(info)
	return self:DbGet("useBackgroundTexture")
end

---Set the background texture
---@param info table AceConfig info table
---@param value string The texture name
function BackgroundTexturable:SetBackgroundTexture(info, value)
	self:DbSet("backgroundTexture", value)
	self:RefreshBackgroundTexture()
end

---Get the background texture
---@param info table AceConfig info table
---@return string|nil The texture name
function BackgroundTexturable:GetBackgroundTexture(info)
	return self:DbGet("backgroundTexture")
end

---Check if background texture selection is disabled
---@param info table AceConfig info table
---@return boolean Whether texture selection is disabled
function BackgroundTexturable:IsBackgroundTextureDisabled(info)
	return self:DbGet("useBackgroundTexture") == false
end

ns.BackgroundTexturable = BackgroundTexturable
