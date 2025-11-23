---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddSizableOptions(optionsTable, orderMap)
    optionsTable.width = {
        type = "range",
        name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_WIDTH,
        min = 1,
        softMin = 50,
        softMax = 800,
        max = 1000000000,
        step = 1,
        bigStep = 10,
        set = "SetWidth",
        get = "GetWidth",
        order = orderMap.WIDTH or 1,
    }
    
    optionsTable.height = {
        type = "range",
        name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_HEIGHT,
        min = 1,
        softMin = 5,
        softMax = 600,
        max = 1000000000,
        step = 1,
        bigStep = 5,
        set = "SetHeight",
        get = "GetHeight",
        order = orderMap.HEIGHT or 2,
    }
end

---@class SizableHandler: BUFConfigHandler
---@field SetSize fun(self: SizableHandler)

---@class Sizable: SizableHandler
local Sizable = {}

function Sizable:SetWidth(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".width", value)
    self:SetSize()
end

function Sizable:GetWidth(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".width")
end

function Sizable:SetHeight(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".height", value)
    self:SetSize()
end

function Sizable:GetHeight(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".height")
end

ns.Sizable = Sizable