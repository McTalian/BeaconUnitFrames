---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddBackgroundTextureOptions(optionsTable, orderMap)
    optionsTable.useBackgroundTexture = {
        type = "toggle",
        name = ns.L["Use Background Texture"],
        desc = ns.L["UseBackgroundTextureDesc"],
        set = "SetUseBackgroundTexture",
        get = "GetUseBackgroundTexture",
        order = orderMap.USE_BACKGROUND_TEXTURE or 10,
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
        order = orderMap.BACKGROUND_TEXTURE or 11,
    }
end

---@class BackgroundTexturableHandler: BUFConfigHandler
---@field RefreshBackgroundTexture fun(self: BackgroundTexturableHandler)

---@class BackgroundTexturable: BackgroundTexturableHandler
local BackgroundTexturable = {}

---Set whether to use a custom background texture
---@param info table AceConfig info table
---@param value boolean Whether to use custom texture
function BackgroundTexturable:SetUseBackgroundTexture(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useBackgroundTexture", value)
    self:RefreshBackgroundTexture()
end

---Get whether to use a custom background texture
---@param info table AceConfig info table
---@return boolean|nil Whether to use custom texture
function BackgroundTexturable:GetUseBackgroundTexture(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useBackgroundTexture")
end

---Set the background texture
---@param info table AceConfig info table
---@param value string The texture name
function BackgroundTexturable:SetBackgroundTexture(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".backgroundTexture", value)
    self:RefreshBackgroundTexture()
end

---Get the background texture
---@param info table AceConfig info table
---@return string|nil The texture name
function BackgroundTexturable:GetBackgroundTexture(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".backgroundTexture")
end

---Check if background texture selection is disabled
---@param info table AceConfig info table
---@return boolean Whether texture selection is disabled
function BackgroundTexturable:IsBackgroundTextureDisabled(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useBackgroundTexture") == false
end

ns.BackgroundTexturable = BackgroundTexturable