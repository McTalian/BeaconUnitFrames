---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFContextMenu
ns.menu = {}

local easyMenu = LibStub("LibEasyMenu")
local menuFrame = CreateFrame("Frame", addonName .. "MenuFrame", UIParent, "UIDropDownMenuTemplate")
local menu = {
	{ text = addonName, isTitle = true, notCheckable = true },
    { text = ns.L["Show/Hide Minimap Icon"], notCheckable = true, func = function()
        local iconState = ns.db.global.minimap.hide
        ns.db.global.minimap.hide = not iconState
        if ns.db.global.minimap.hide then
            ns.brokerIcon:Hide(addonName)
        else
            ns.brokerIcon:Show(addonName)
        end
    end },
}
function ns.menu:OpenOptions(button)
    if button == "LeftButton" then
		ns.acd:Open(addonName)
	elseif button == "RightButton" then
		local tmpMenu = {}
		for _, item in ipairs(menu) do
			table.insert(tmpMenu, item)
		end
		table.insert(tmpMenu, {
			text = ns.L["Close"],
			func = function()
				CloseDropDownMenus()
			end,
			notCheckable = true,
		})
		easyMenu:EasyMenu(tmpMenu, menuFrame, "cursor", 0, 0, "MENU")
	end
end
