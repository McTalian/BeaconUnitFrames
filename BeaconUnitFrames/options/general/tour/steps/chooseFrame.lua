---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

local manager = ns.TourManager

local stepName = "chooseFrame"

ns.TourStepFactory:Create(stepName, {
	text = ns.L["TourChooseFrame"],
	targetPoint = HelpTip.Point.BottomEdgeRight,
	frame = function(self)
		local root = manager:getOptionsRoot()
		if not root then
			return nil
		end
		local dropdown = root.children[1].dropdown
		return dropdown.frame
	end,

	navigate = function(self, callback)
		ns.acd:SelectGroup(addonName, "general")
		callback()
	end,
})
