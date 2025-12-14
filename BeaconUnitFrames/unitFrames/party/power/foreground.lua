---@class BUFNamespace
local ns = select(2, ...)

---@class BUFParty
local BUFParty = ns.BUFParty

---@class BUFParty.Power
local BUFPartyPower = BUFParty.Power

---@class BUFParty.Power.Foreground: StatusBarForeground
local foregroundHandler = {
	configPath = "unitFrames.party.powerBar.foreground",
}

foregroundHandler.optionsTable = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFPartyPower.topGroupOrder.FOREGROUND,
	args = {},
}

---@class BUFDbSchema.UF.Party.Power.Foreground
foregroundHandler.dbDefaults = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

ns.StatusBarForeground:ApplyMixin(foregroundHandler, false, false, true)

---@class BUFDbSchema.UF.Party.Power
ns.dbDefaults.profile.unitFrames.party.powerBar = ns.dbDefaults.profile.unitFrames.party.powerBar
ns.dbDefaults.profile.unitFrames.party.powerBar.foreground = foregroundHandler.dbDefaults

ns.options.args.party.args.powerBar.args.foreground = foregroundHandler.optionsTable

function foregroundHandler:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		for i, bpi in ipairs(BUFParty.frames) do
			bpi.power.foreground = {}
			bpi.power.foreground.statusBar = bpi.manaBar
			bpi.power.foreground.maskTexture = bpi.manaBar.ManaBarMask
			bpi.power.foreground.unit = "party" .. i

			-- if not BUFParty:IsHooked(bpi.power.foreground.statusBar, "SetStatusBarTexture") then
			-- 	BUFParty:SecureHook(bpi.power.foreground.statusBar, "SetStatusBarTexture", function(s, texture)
			-- 		local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, self:GetStatusBarTexture())
			-- 		if texture == texturePath then
			-- 			-- print("Ignoring, we're setting this ourselves", bpi.power.foreground.unit)
			-- 			return
			-- 		else
			-- 			print("Texture was set externally, refreshing our config", texture, bpi.power.foreground.unit)
			-- 			self:_RefreshStatusBarTexture(s)
			-- 		end
			-- 	end)
			-- end
		end
		self.defaultStatusBarTexture = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana"
	end
	self:RefreshStatusBarForegroundConfig()
end

function foregroundHandler:RefreshStatusBarTexture()
	local useCustomTexture = self:GetUseStatusBarTexture()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_RefreshStatusBarTexture(bpi.power.foreground.statusBar)
		if useCustomTexture then
			bpi.power.foreground.maskTexture:Hide()
		end
	end
end

function foregroundHandler:RefreshColor()
	for _, bpi in ipairs(BUFParty.frames) do
		self:_RefreshColor(bpi.power.foreground.statusBar, bpi.power.foreground.unit)
	end
end

BUFPartyPower.foregroundHandler = foregroundHandler
