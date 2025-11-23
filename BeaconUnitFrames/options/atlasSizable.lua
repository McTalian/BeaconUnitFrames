---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddAtlasSizableOptions(optionsTable, orderMap)
    optionsTable.useAtlasSize = {
        type = "toggle",
        name = ns.L["UseAtlasSize"],
        desc = ns.L["UseAtlasSizeDesc"],
        set = "SetUseAtlasSize",
        get = "GetUseAtlasSize",
        order = orderMap.USE_ATLAS_SIZE or 6,
    }

    ns.AddSizableOptions(optionsTable, {
        WIDTH = orderMap.WIDTH or 2,
        HEIGHT = orderMap.HEIGHT or 3,
    })
end

---@class AtlasSizableHandler: SizableHandler

---@class AtlasSizable: AtlasSizableHandler
local AtlasSizable = {}

function AtlasSizable:SetUseAtlasSize(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useAtlasSize", value)
    self:SetSize()
end

function AtlasSizable:GetUseAtlasSize(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useAtlasSize")
end

ns.AtlasSizable = AtlasSizable
