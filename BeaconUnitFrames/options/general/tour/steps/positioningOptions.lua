---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

local manager = ns.TourManager

local stepName = "positioningOptions"

ns.TourStepFactory:Create(stepName, {
	text = ns.L["TourPositioningOptions"],
	targetPoint = HelpTip.Point.TopEdgeCenter,
	frame = function(self)
		local root = manager:getOptionsRoot()
		if not root then
			return nil
		end
		local positioningHeader = root.children[1].children[3].children[1].children[6]
		return positioningHeader.frame
	end,

	navigate = function(self, callback)
		ns.acd:SelectGroup(addonName, "player", "portrait")
		callback()
	end,
})
