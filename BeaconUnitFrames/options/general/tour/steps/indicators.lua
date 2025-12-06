---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

local manager = ns.TourManager

local stepName = "indicators"

ns.TourStepFactory:Create(stepName, {
	text = ns.L["TourIndicatorsAndIcons"],
	targetPoint = HelpTip.Point.BottomEdgeCenter,
	frame = function(self)
		local root = manager:getOptionsRoot()
		if not root then
			return nil
		end
		local statusBarHeader = root.children[1].children[3].children[1].children[1]
		return statusBarHeader.frame
	end,

	navigate = function(self, callback)
		ns.acd:SelectGroup(addonName, "player", "indicators", "attackIcon")
		callback()
	end,
})
