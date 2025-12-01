---@class BUFNamespace
local ns = select(2, ...)

--- Add sizable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddSizableOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.sizing = optionsTable.sizing or {
        type = "header",
        name = ns.L["Sizing"],
        order = orderMap.SIZING_HEADER,
    }

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
        order = orderMap.WIDTH,
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
        order = orderMap.HEIGHT,
    }
end

---@class SizableHandler: BUFConfigHandler
---@field SetSize fun(self: SizableHandler)
---@field _SetSize fun(self: SizableHandler, sizable: ScriptRegionResizing)

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
function Sizable:_SetSize(sizable)
    local width = self:GetWidth()
    local height = self:GetHeight()
    if width then
        sizable:SetWidth(width)
    end
    if height then
        sizable:SetHeight(height)
    end
end

ns.Sizable = Sizable