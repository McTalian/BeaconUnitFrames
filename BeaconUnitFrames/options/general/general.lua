---@class BUFNamespace
local ns = select(2, ...)

---@class BUFOptionsGeneral: BUFParentHandler
local OptionsGeneral = {}

ns.options.args.general = {
	type = "group",
	name = GENERAL,
	order = 0.5,
	childGroups = "tree",
	args = {},
}

OptionsGeneral.optionsOrder = {
	LANDING_PAGE = 1,
}

ns.OptionsGeneral = OptionsGeneral
