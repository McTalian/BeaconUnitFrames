---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

local acr = LibStub("AceConfigRegistry-3.0") --[[@as AceConfigRegistry-3.0]]

---@class BUFOptionsLandingPage: BUFConfigHandler
local LandingPage = {}

LandingPage.optionsOrder = {
	TITLE = 1,
	IMAGE = 2,
	TOUR = 3,
}

LandingPage.optionsTable = {
	type = "group",
	name = ns.L["LandingPage"],
	handler = LandingPage,
	order = ns.OptionsGeneral.optionsOrder.LANDING_PAGE,
	args = {
		title = {
			type = "header",
			name = ns.L["LandingPageDesc"],
			order = LandingPage.optionsOrder.TITLE,
		},
		image = {
			type = "description",
			name = "",
			image = function()
				local path = "Interface/AddOns/BeaconUnitFrames/icons/logo.png"
				local width = 256
				local height = 256
				return path, width, height
			end,
			order = LandingPage.optionsOrder.IMAGE,
		},
		tour = {
			type = "execute",
			name = ns.L["Tour"],
			desc = ns.L["TourDesc"],
			func = "LaunchTour",
			order = LandingPage.optionsOrder.TOUR,
		},
	},
}

---@class HelpTipInfoTable
---@field text string
---@field textColor? Color
---@field textJustifyH? string
---@field buttonStyle? HelpTip.ButtonStyle
---@field targetPoint? HelpTip.Point
---@field alignment? HelpTip.Alignment
---@field hideArrow? boolean
---@field offsetX? number
---@field offsetY? number
---@field cvar? string
---@field cvarValue? string
---@field cvarBitfield? number
---@field bitfieldFlag? number
---@field onHideCallback? fun(acknowledged: boolean, arg: any)
---@field callbackArg? any
---@field onAcknowledgeCallback? fun(arg: any)
---@field checkCVars? boolean
---@field autoEdgeFlipping? boolean
---@field autoHorizontalSlide? boolean
---@field useParentStrata? boolean
---@field system? string
---@field systemPriority? number
---@field extraRightMarginPadding? number
---@field acknowledgeOnHide? boolean
---@field handlesGlobalMouseEventCallback? fun()
---@field appendFrame? Frame
---@field appendFrameYOffset? number
---@field autoHideWhenTargetHides? boolean
---@field ignoreInParentLayout? boolean

---@class BUFHelpTipStep: HelpTipInfoTable
---@field frame fun(): Frame

function LandingPage:Initialize()
	---@type table<string, BUFHelpTipStep>
	local root = ns.acd.OpenFrames[addonName]

	self.parentFrame = root.frame
	self.steps = {
		chooseFrame = {
			text = ns.L["TourChooseFrame"],
			alignment = HelpTip.Alignment.Center,
			buttonStyle = HelpTip.ButtonStyle.Next,
			targetPoint = HelpTip.Point.BottomEdgeRight,
			frame = function()
				local dropdown = root.children[1].dropdown
				return dropdown.frame
			end,
			onAcknowledgeCallback = function()
				-- Next step
				ns.acd:SelectGroup(addonName, "player")
				RunNextFrame(function()
					local nextStep = self.steps.playerTourGeneral
					HelpTip:Show(self.parentFrame, nextStep, nextStep.frame())
				end)
			end,
			useParentStrata = true,
		},
		playerTourGeneral = {
			text = "Each frame has stuff",
			alignment = HelpTip.Alignment.Left,
			buttonStyle = HelpTip.ButtonStyle.Next,
			targetPoint = HelpTip.Point.RightEdgeCenter,
			frame = function()
				local splitPanel = root.children[1].children[3]
				return splitPanel.treeframe
			end,
			useParentStrata = true,
		},
	}
end

function LandingPage:LaunchTour()
	self:Initialize()
	local initialFrame = self.steps.chooseFrame.frame()
	if initialFrame == nil then
		return
	end
	HelpTip:Show(self.parentFrame, self.steps.chooseFrame, initialFrame)
end

ns.options.args.general.args.landingPage = LandingPage.optionsTable

ns.LandingPage = LandingPage
