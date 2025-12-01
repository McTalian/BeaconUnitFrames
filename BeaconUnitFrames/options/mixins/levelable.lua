---@class BUFNamespace
local ns = select(2, ...)

--- Add frame level option to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddFrameLevelOption(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.positioning = optionsTable.positioning or {
        type = "header",
        name = ns.L["Positioning"],
        order = orderMap.POSITIONING_HEADER,
    }

    optionsTable.frameLevel = {
        type = "range",
        name = ns.L["Frame Level"],
        min = 0,
        max = 10000,
        step = 1,
        bigStep = 10,
        set = "SetFrameLevel",
        get = "GetFrameLevel",
        order = orderMap.FRAME_LEVEL,
    }
end

---@class LevelableHandler: BUFConfigHandler
---@field SetLevel fun(self: LevelableHandler)

---@class Levelable: LevelableHandler
local Levelable = {}

function Levelable:SetFrameLevel(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".frameLevel", value)
    self:SetLevel()
end

function Levelable:GetFrameLevel(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".frameLevel")
end

--- Set the frame level of the given frame
--- @param self Levelable
--- @param frame Frame
function Levelable:_SetLevel(frame)
    local frameLevel = self:GetFrameLevel()
    if frame and frame.IsUsingParentLevel and frame:IsUsingParentLevel() then
        frame:SetUsingParentLevel(false)
    end
    frame:SetFrameLevel(frameLevel)
end

ns.Levelable = Levelable