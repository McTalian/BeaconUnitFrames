---@class BUFNamespace
local ns = select(2, ...)

local manager = ns.TourManager

---@class BUFTourStepFactory
local TourStepFactory = {}

---@class BUFTourStepConfig: HelpTipInfoTable
---@field frame fun(self): Frame|nil
---@field navigate fun(self, callback)
---@field start? fun(self)

---@class BUFTourStep: BUFTourStepConfig
---@field bufName string

local defaultBUFHelpTipStep = {
	alignment = HelpTip.Alignment.Center,
	buttonStyle = HelpTip.ButtonStyle.Next,
	useParentStrata = true,
	onAcknowledgeCallback = function(self)
		manager:acknowledgeStep(self.bufName)

		local nextKey = manager:getNextStep()
		if not nextKey then
			manager:FinishTour()
			return
		end
		local next = manager.steps[nextKey]
		if next then
			next:start()
		end
	end,
	_asyncShowHelpTip = function(self)
		local root = manager:getOptionsRootFrame()
		if not root then
			return
		end
		local step = self
		local show = function()
			RunNextFrame(function()
				HelpTip:Show(root, step, step:frame())
			end)
		end
		if step.navigate then
			step:navigate(show)
			return
		elseif not step:frame() then
			error("Tour step frame not found")
			return
		end

		show()
	end,
	start = function(self)
		self:_asyncShowHelpTip()
	end,
}

--- Creates and returns a new Tour Step instance
---@param name string
---@param config BUFTourStepConfig
function TourStepFactory:Create(name, config, noAppend)
	local step = {}
	ns.Mixin(step, defaultBUFHelpTipStep, config)
	step.callbackArg = step
	step.bufName = name

	if noAppend then
		return step
	end
	table.insert(manager.stepsOrder, name)
	---@type BUFTourStep
	manager.steps[name] = step
end

ns.TourStepFactory = TourStepFactory
