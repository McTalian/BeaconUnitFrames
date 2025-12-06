---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

local manager = ns.TourManager

local stepName = "portraitSpecialOptions"

ns.TourStepFactory:Create(stepName, {
	text = ns.L["TourPortraitSpecialOptions"],
	targetPoint = HelpTip.Point.RightEdgeCenter,
	frame = function(self)
		local root = manager:getOptionsRoot()
		if not root then
			return nil
		end
		local cornerIndicatorOption = root.children[1].children[3].children[1].children[2]
		return cornerIndicatorOption.frame
	end,

	navigate = function(self, callback)
		ns.acd:SelectGroup(addonName, "player", "portrait")
		callback()
	end,
})
