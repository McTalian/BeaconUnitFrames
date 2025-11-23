---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddAtlasScalableOptions(optionsTable, orderMap)
    optionsTable.useAtlasSize = {
        type = "toggle",
        name = ns.L["UseAtlasSize"],
        desc = ns.L["UseAtlasSizeDesc"],
        set = "SetUseAtlasScale",
        get = "GetUseAtlasScale",
        order = orderMap.USE_ATLAS_SIZE or 4,
    }

    ns.AddScalableOptions(optionsTable, {
        SCALE = orderMap.SCALE or 5,
    })
end

---@class AtlasScalableHandler: ScalableHandler

---@class AtlasScalable: AtlasScalableHandler
local AtlasScalable = {}

function AtlasScalable:SetUseAtlasScale(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useAtlasScale", value)
    self:SetScaleFactor()
end

function AtlasScalable:GetUseAtlasScale(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useAtlasScale")
end

ns.AtlasScalable = AtlasScalable
