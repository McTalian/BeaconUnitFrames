---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.addonVersion = "@project-version@"

---@class BUFAddon: AceAddon, AceConsole-3.0, AceEvent-3.0
local BUF = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")
ns.BUF = BUF

ns.localeName = addonName .. "Locale"

function ns.noop() end

ns.lsm = LibStub("LibSharedMedia-3.0")
ns.acd = LibStub("AceConfigDialog-3.0") --[[@as AceConfigDialog-3.0]]
ns.brokerIcon = LibStub("LibDBIcon-1.0")
ns.PP = LibStub("LibPixelPerfect-1.0")

function BUF:OnInitialize()
    ns.DbManager:Initialize()
    ns.OptionsManager:Initialize()

    self.broker = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
        type = "launcher",
        text = addonName,
        icon = "Interface/AddOns/BeaconUnitFrames/icons/logo",
        OnClick = function(og_frame, button)
			ns.menu:OpenOptions(button)
		end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine(addonName)
            tooltip:AddLine("Left-Click to open settings.")
            tooltip:AddLine("Right-Click for quick options.")
        end,
    })

    ns.brokerIcon:Register(addonName, self.broker, ns.db.global.minimap)
	ns.brokerIcon:AddButtonToCompartment(addonName)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterChatCommand("buf", "SlashCommand")
	self:RegisterChatCommand("BUF", "SlashCommand")
	self:RegisterChatCommand("beacon", "SlashCommand")
end

function BUF:RefreshConfig()
    ns.BUFPlayer:RefreshConfig()
    ns.BlizzHack.Initialize()
    ns.BUFTarget:RefreshConfig()
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

---@alpha@
_G["BeaconUnitFrames"] = ns
---@end-alpha@
