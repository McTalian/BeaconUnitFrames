---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.AtlasSizableFlags = {
    NONE = 0x0,
    SIZABLE = 0x1,
    SCALABLE = 0x2,
}

--- Add atlas sizable options to the given options table
--- @param optionsTable table
--- @param _flags number?
--- @param _orderMap BUFOptionsOrder?
function ns.AddAtlasSizableOptions(optionsTable, _flags, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap
    optionsTable.useAtlasSize = {
        type = "toggle",
        name = ns.L["UseAtlasSize"],
        desc = ns.L["UseAtlasSizeDesc"],
        set = "SetUseAtlasSize",
        get = "GetUseAtlasSize",
        order = orderMap.USE_ATLAS_SIZE,
    }

    local flags = _flags or ns.AtlasSizableFlags.SIZABLE
    if bit.band(flags, ns.AtlasSizableFlags.SIZABLE) == ns.AtlasSizableFlags.SIZABLE then
        ns.AddSizableOptions(optionsTable, orderMap)
    end
    if bit.band(flags, ns.AtlasSizableFlags.SCALABLE) == ns.AtlasSizableFlags.SCALABLE then
        ns.AddScalableOptions(optionsTable, orderMap)
    end
end

---@class AtlasSizableHandler: SizableHandler, ScalableHandler
---@field atlasName? string
---@field _SetSize fun(self: AtlasSizableHandler, atlasSizable: TextureBase)

---@class AtlasSizable: AtlasSizableHandler, Sizable
local AtlasSizable = {}

function AtlasSizable:ApplyMixin(handler, flags)
    if bit.band(flags, ns.AtlasSizableFlags.SIZABLE) == ns.AtlasSizableFlags.SIZABLE then
        self.sizable = true
        ns.ApplyMixin(ns.Sizable, handler)
    end
    if bit.band(flags, ns.AtlasSizableFlags.SCALABLE) == ns.AtlasSizableFlags.SCALABLE then
        self.scalable = true
        ns.ApplyMixin(ns.Scalable, handler)
    end
    ns.ApplyMixin(self, handler)
end

function AtlasSizable:SetUseAtlasSize(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useAtlasSize", value)
    if self.sizable then
        self:SetSize()
    end
    if self.scalable then
        self:SetScaleFactor()
    end
end

function AtlasSizable:GetUseAtlasSize(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useAtlasSize")
end

function AtlasSizable:_SetSize(atlasSizable)
    local useAtlasSize = self:GetUseAtlasSize()
    local width, height = self:GetWidth(), self:GetHeight()

    if useAtlasSize and self.atlasName then
        atlasSizable:SetAtlas(self.atlasName, true)
    else
        atlasSizable:SetAtlas(self.atlasName, false)
        atlasSizable:SetWidth(width)
        atlasSizable:SetHeight(height)
    end
end

ns.AtlasSizable = AtlasSizable
