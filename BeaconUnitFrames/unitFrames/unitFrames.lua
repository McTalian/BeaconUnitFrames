---@class BUFNamespace
local ns = select(2, ...)

---@class BUFDbSchema: AceDB.Schema
ns.dbDefaults = ns.dbDefaults

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = {}

---@class BUFUnitFrames
local UnitFrames = {}

UnitFrames.optionsOrder = {
	PLAYER = 1,
	TARGET = 2,
	PET = 3,
	FOCUS = 4,
	TOT = 5,
	TOFOCUS = 6,
	PARTY = 7,
	BOSS = 8,
}

-- Each unit frame module registers itself
local registeredFrames = {}

function UnitFrames:RegisterFrame(frameModule)
	table.insert(registeredFrames, frameModule)
end

function UnitFrames:RefreshConfig()
	for _, frameModule in ipairs(registeredFrames) do
		if frameModule.RefreshConfig then
			frameModule:RefreshConfig()
		else
			error("Frame module " .. tostring(frameModule) .. " is missing RefreshConfig method")
		end
	end
end

ns.BUFUnitFrames = UnitFrames
