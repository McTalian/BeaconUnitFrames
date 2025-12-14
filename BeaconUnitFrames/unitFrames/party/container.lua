---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Container
local BUFPartyContainer = {
	configPath = "unitFrames.party.container",
}

function BUFPartyContainer:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.container = PartyFrame
	end
end

BUFParty.Container = BUFPartyContainer
