---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

--- Add atlas scalable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddAtlasScalableOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    optionsTable.useAtlasSize = {
        type = "toggle",
        name = ns.L["UseAtlasSize"],
        desc = ns.L["UseAtlasSizeDesc"],
        set = "SetUseAtlasScale",
        get = "GetUseAtlasScale",
        order = orderMap.USE_ATLAS_SIZE,
    }

    ns.AddScalableOptions(optionsTable, orderMap)
end

---@class AtlasScalableHandler: ScalableHandler

---@class AtlasScalable: AtlasScalableHandler
local AtlasScalable = {}

ns.ApplyMixin(ns.Scalable, AtlasScalable)

function AtlasScalable:SetUseAtlasScale(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useAtlasScale", value)
    self:SetScaleFactor()
end

function AtlasScalable:GetUseAtlasScale(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useAtlasScale")
end

ns.AtlasScalable = AtlasScalable
