---@type string
local addonName = select(1, ...)
---@class BUFNamespace
local ns = select(2, ...)

local brokerIconLib = LibStub("LibDBIcon-1.0")

---@class MenuManager
local MenuManager = {}

function MenuManager:Initialize()
	self.easyMenu = LibStub("LibEasyMenu")
	self.menuFrame = CreateFrame("Frame", addonName .. "MenuFrame", UIParent, "UIDropDownMenuTemplate")
	self.menu = {
		{ text = addonName, isTitle = true, notCheckable = true },
		{
			text = ns.L["Show/Hide Minimap Icon"],
			notCheckable = true,
			func = function()
				local iconState = ns.db.global.minimap.hide
				ns.db.global.minimap.hide = not iconState
				if ns.db.global.minimap.hide then
					brokerIconLib:Hide(addonName)
				else
					brokerIconLib:Show(addonName)
				end
			end,
		},
	}
end

function MenuManager:OpenOptions(button)
	if button == "LeftButton" then
		ns.acd:Open(addonName)
	elseif button == "RightButton" then
		local tmpMenu = {}
		for _, item in ipairs(self.menu) do
			table.insert(tmpMenu, item)
		end
		table.insert(tmpMenu, {
			text = CLOSE,
			func = function()
				CloseDropDownMenus()
			end,
			notCheckable = true,
		})
		self.easyMenu:EasyMenu(tmpMenu, self.menuFrame, "cursor", 0, 0, "MENU")
	end
end

---@class BrokerManager
local BrokerManager = {}

function BrokerManager:Initialize()
	MenuManager:Initialize()

	self.broker = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
		type = "launcher",
		text = addonName,
		icon = "Interface/AddOns/BeaconUnitFrames/icons/logo.png",
		OnClick = function(og_frame, button)
			MenuManager:OpenOptions(button)
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(addonName)
			tooltip:AddLine("Left-Click to open settings.")
			tooltip:AddLine("Right-Click for quick options.")
		end,
	})

	brokerIconLib:Register(addonName, self.broker, ns.db.global.minimap)
	brokerIconLib:AddButtonToCompartment(addonName)
end

ns.BrokerManager = BrokerManager
