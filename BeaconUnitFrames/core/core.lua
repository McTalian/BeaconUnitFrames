---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

ns.addonVersion = "@project-version@"
ns.acd = LibStub("AceConfigDialog-3.0") --[[@as AceConfigDialog-3.0]]
ns.PP = LibStub("LibPixelPerfect-1.0")

function ns.TableToCommaSeparatedString(tbl)
	local result = {}
	for key, value in pairs(tbl) do
		if value then
			table.insert(result, key)
		end
	end
	return table.concat(result, ", ")
end

---@class BUFAddon: AceAddon, AceConsole-3.0, AceEvent-3.0
local BUF = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")

function BUF:OnInitialize()
	ns.DbManager:Initialize()
	ns.OptionsManager:Initialize()
	ns.BrokerManager:Initialize()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterChatCommand("buf", "SlashCommand")
	self:RegisterChatCommand("BUF", "SlashCommand")
	self:RegisterChatCommand("beacon", "SlashCommand")
end

function BUF:RefreshConfig()
	ns.BUFUnitFrames:RefreshConfig()
end

function BUF:SlashCommand(msg, editBox)
	ns.acd:Open(addonName)
end

function BUF:PLAYER_ENTERING_WORLD(_, isLogin, isReload)
	if self.optionsFrame == nil then
		self.optionsFrame = ns.acd:AddToBlizOptions(addonName, addonName)
	end

	local isNewVersion = ns.addonVersion ~= ns.db.global.lastVersionLoaded
	if isLogin and isReload == false and isNewVersion then
		ns.db.global.lastVersionLoaded = ns.addonVersion
	end

	self:RefreshConfig()
end

ns.BUF = BUF

---@alpha@
_G["BeaconUnitFrames"] = ns
---@end-alpha@
