---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

local manager = ns.TourManager

local stepName = "playerGeneral"

ns.TourStepFactory:Create(stepName, {
	text = ns.L["TourPlayerGeneral"],
	targetPoint = HelpTip.Point.RightEdgeCenter,
	frame = function(self)
		local root = manager:getOptionsRoot()
		if not root then
			return nil
		end
		local splitPanel = root.children[1].children[3]
		return splitPanel.treeframe
	end,

	navigate = function(self, callback)
		ns.acd:SelectGroup(addonName, "player")
		callback()
	end,
})
