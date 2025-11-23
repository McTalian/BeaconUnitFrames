---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

function ns.AddReactionColorOptions(optionsTable, orderMap)
    optionsTable.useReactionColor = {
        type = "toggle",
        name = ns.L["Use Reaction Color"],
        desc = ns.L["UseReactionColorDesc"],
        set = "SetUseReactionColor",
        get = "GetUseReactionColor",
        order = orderMap.REACTION_COLOR or 13,
    }
end

---@class ReactionColorable: ColorableHandler
local ReactionColorable = {}

---Set whether to use class color
---@param info table AceConfig info table
---@param value boolean Whether to use class color
function ReactionColorable:SetUseReactionColor(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".useReactionColor", value)
    self:RefreshColor()
end

---Get whether to use class color
---@param info table AceConfig info table
---@return boolean|nil Whether to use class color
function ReactionColorable:GetUseReactionColor(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useReactionColor")
end

ns.ReactionColorable = ReactionColorable
