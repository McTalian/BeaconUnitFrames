---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add atlas sizable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddAtlasSizableOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    optionsTable.useAtlasSize = {
        type = "toggle",
        name = ns.L["UseAtlasSize"],
        desc = ns.L["UseAtlasSizeDesc"],
        set = "SetUseAtlasSize",
        get = "GetUseAtlasSize",
        order = orderMap.USE_ATLAS_SIZE,
    }

    ns.AddSizableOptions(optionsTable, orderMap)
end

---@class AtlasSizableHandler: SizableHandler

---@class AtlasSizable: AtlasSizableHandler
local AtlasSizable = {}

ns.ApplyMixin(ns.Sizable, AtlasSizable)

function AtlasSizable:SetUseAtlasSize(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useAtlasSize", value)
    self:SetSize()
end

function AtlasSizable:GetUseAtlasSize(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useAtlasSize")
end

ns.AtlasSizable = AtlasSizable
