---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.dbDefaults.profile.emergencyFixButton = {
    width = 100,
    height = 100,
    anchorPoint = "CENTER",
    relativeTo = "UIParent",
    relativePoint = "CENTER",
    xOffset = 0,
    yOffset = 0,
}

local emergencyWrapper = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")

print("Creating emergency fix button wrapper")

function emergencyWrapper:Inject(name, frame)
    self:SetFrameRef(name, frame)
end

local emergencyFixButton = CreateFrame("Button", nil, nil, "SecureActionButtonTemplate")

emergencyFixButton:SetSize(100, 100)
emergencyFixButton:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
emergencyFixButton:SetNormalAtlas("bags-button-autosort-up")
emergencyFixButton:SetPushedAtlas("bags-button-autosort-down")
emergencyFixButton:SetText("Emergency Fix!")
emergencyFixButton:Hide()
emergencyFixButton:SetAttribute("type", "attribute")
emergencyFixButton:SetAttribute("typerelease", "attribute")
emergencyFixButton:SetAttribute("attribute-frame", emergencyWrapper)
emergencyFixButton:SetAttribute("attribute-name", "force-refresh")
emergencyFixButton:SetAttribute("attribute-value", true)
emergencyFixButton:RegisterForClicks("AnyDown")
emergencyWrapper:SetFrameRef("EmergencyFix", emergencyFixButton)
emergencyWrapper:SetAttribute("_onattributechanged", [[
    print(name, value)
    local playerVehicleListener = self:GetFrameRef("PlayerVehicleListener")
    if name == "force-refresh" and value == true then
        playerVehicleListener:SetAttribute(name, value)
        local emergencyFix = self:GetFrameRef("EmergencyFix")
        emergencyFix:Hide()
    end
]])

ns.emergencyFixButtonWrapper = emergencyWrapper
ns.emergencyFixButton = emergencyFixButton
