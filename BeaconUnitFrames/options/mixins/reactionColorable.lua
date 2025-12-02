---@class BUFNamespace
local ns = select(2, ...)

--- Add reaction color options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddReactionColorOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap

	optionsTable.coloring = optionsTable.coloring
		or {
			type = "header",
			name = ns.L["Coloring"],
			order = orderMap.COLORING_HEADER,
		}

	optionsTable.useReactionColor = {
		type = "toggle",
		name = ns.L["Use Reaction Color"],
		set = "SetUseReactionColor",
		get = "GetUseReactionColor",
		order = orderMap.REACTION_COLOR,
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
---@param info? table AceConfig info table
---@return boolean|nil Whether to use class color
function ReactionColorable:GetUseReactionColor(info)
	return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".useReactionColor")
end

ns.ReactionColorable = ReactionColorable
