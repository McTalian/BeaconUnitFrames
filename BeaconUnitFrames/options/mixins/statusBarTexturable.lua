---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add status bar texture options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddStatusBarTextureOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.statusBarHeader = optionsTable.statusBarHeader or {
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

---@class StatusBarTexturableHandler: BUFConfigHandler
---@field RefreshStatusBarTexture fun(self: StatusBarTexturableHandler)

---@class StatusBarTexturable: StatusBarTexturableHandler
local StatusBarTexturable = {}

---Set whether to use a custom status bar texture
---@param info table AceConfig info table
---@param value boolean Whether to use custom texture
function StatusBarTexturable:SetUseStatusBarTexture(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useStatusBarTexture", value)
    self:RefreshStatusBarTexture()
end

---Get whether to use a custom status bar texture
---@param info? table AceConfig info table
---@return boolean|nil Whether to use custom texture
function StatusBarTexturable:GetUseStatusBarTexture(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useStatusBarTexture")
end

---Set the status bar texture
---@param info table AceConfig info table
---@param value string The texture name
function StatusBarTexturable:SetStatusBarTexture(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".statusBarTexture", value)
    self:RefreshStatusBarTexture()
end

---Get the status bar texture
---@param info? table AceConfig info table
---@return string|nil The texture name
function StatusBarTexturable:GetStatusBarTexture(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".statusBarTexture")
end

---Check if status bar texture selection is disabled
---@param info table AceConfig info table
---@return boolean Whether texture selection is disabled
function StatusBarTexturable:IsStatusBarTextureDisabled(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useStatusBarTexture") == false
end

ns.StatusBarTexturable = StatusBarTexturable