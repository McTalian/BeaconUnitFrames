---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

local acr = LibStub("AceConfigRegistry-3.0") --[[@as AceConfigRegistry-3.0]]
local acd = ns.acd --[[@as AceConfigDialog-3.0]]

---@class HelpTipInfoTable
---@field text string
---@field textColor? Color = HIGHLIGHT_FONT_COLOR
---@field textJustifyH? "LEFT" | "CENTER" | "RIGHT" = "LEFT"
---@field buttonStyle? HelpTip.ButtonStyle = HelpTip.ButtonStyle.None
---@field targetPoint? HelpTip.Point = HelpTip.Point.BottomEdgeCenter
---@field alignment? HelpTip.Alignment = HelpTip.Alignment.Center
---@field hideArrow? boolean = false
---@field offsetX? number = 0
---@field offsetY? number = 0
---@field cvar? string = nil
---@field cvarValue? string
---@field cvarBitfield? number
---@field bitfieldFlag? number
---@field onHideCallback? fun(acknowledged: boolean, arg: any)
---@field callbackArg? any
---@field onAcknowledgeCallback? fun(arg: any)
---@field checkCVars? boolean = false
---@field autoEdgeFlipping? boolean = false
---@field autoHorizontalSlide? boolean = false
---@field useParentStrata? boolean = false
---@field system? string = ""
---@field systemPriority? number = 0
---@field extraRightMarginPadding? number = 0
---@field acknowledgeOnHide? boolean = false
---@field handlesGlobalMouseEventCallback? fun() = nil
---@field appendFrame? Frame = nil
---@field appendFrameYOffset? number = nil
---@field autoHideWhenTargetHides? boolean = false
---@field ignoreInParentLayout? boolean = true

---@class TourManager: BUFDbBackedHandler
local TourManager = {
	configPath = "tour",
}

TourManager.dbDefaults = {
	["**"] = {
		acknowledged = false,
	},
}

--- Will be populated by the individual step files
TourManager.steps = {}
TourManager.stepsOrder = {}

ns.Mixin(TourManager, ns.GlobalDbBackedHandler)

ns.dbDefaults.global.tour = TourManager.dbDefaults

function TourManager:LaunchTour()
	print(self.dbKey, self.configPath)
	print("Launching Tour with ", #self.stepsOrder, " steps.")
	self:DbClear()
	self:ContinueTour()
end

function TourManager:ContinueTour()
	local nextStepKey = self:getNextStep()
	if nextStepKey == nil then
		print("No more tour steps to show.")
		return
	end
	local step = self.steps[nextStepKey]
	if not step then
		print("Tour step not found: ", nextStepKey)
		return
	end
	step:start()
end

function TourManager:FinishTour()
	print("Tour finished.")
end

function TourManager:getOptionsRootFrame()
	local root = self:getOptionsRoot()
	if not root or not root.frame then
		print("no root options frame found")
		return nil
	end
	return root.frame
end

function TourManager:getOptionsRoot()
	local root = ns.acd.OpenFrames[addonName]
	if not root then
		print("no open options for addon found")
		return nil
	end
	return root
end

function TourManager:acknowledgeStep(stepKey)
	TourManager:DbSet(stepKey .. ".acknowledged", true)
end

function TourManager:getNextStep()
	for _, stepKey in ipairs(self.stepsOrder) do
		local acknowledged = TourManager:DbGet(stepKey .. ".acknowledged", false)
		if not acknowledged then
			return stepKey
		end
	end
	return nil
end

function TourManager:areAllAcknowledged()
	for _, stepKey in ipairs(self.stepsOrder) do
		local acknowledged = TourManager:DbGet(stepKey .. ".acknowledged", false)
		if not acknowledged then
			return false
		end
	end
	return true
end

function TourManager:areAllUnacknowledged()
	for _, stepKey in ipairs(self.stepsOrder) do
		local acknowledged = TourManager:DbGet(stepKey .. ".acknowledged", false)
		if acknowledged then
			return false
		end
	end
	return true
end

ns.TourManager = TourManager
