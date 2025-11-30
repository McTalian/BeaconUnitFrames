---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.ReputationBar: BUFConfigHandler, Positionable, Sizable, Colorable, ReactionColorable, ClassColorable
local BUFTargetReputationBar = {
    configPath = "unitFrames.target.reputationBar",
}

ns.Mixin(BUFTargetReputationBar, ns.Sizable, ns.Positionable, ns.Colorable, ns.ClassColorable, ns.ReactionColorable)

BUFTarget.ReputationBar = BUFTargetReputationBar

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target

---@class BUFDbSchema.UF.Target.ReputationBar
ns.dbDefaults.profile.unitFrames.target.reputationBar = {
    width = 134,
    height = 10,
    anchorPoint = "TOPRIGHT",
    relativeTo = "TargetFrame",
    relativePoint = "TOPRIGHT",
    xOffset = -75,
    yOffset = -25,
    atlasTexture = "UI-HUD-UnitFrame-Target-PortraitOn-Type",
    useCustomColor = false,
    customColor = { 0.8, 0.8, 0.2, 1 },
    useReactionColor = true,
    useClassColor = false,
}

local repBar = {
    type = "group",
    name = ns.L["Reputation Bar"],
    handler = BUFTargetReputationBar,
    order = BUFTarget.optionsOrder.REPUTATION_BAR,
    args = {
        atlasTexture = {
            type = "select",
            name = ns.L["Atlas Texture"],
            desc = ns.L["AtlasTextureDesc"],
            order = ns.defaultOrderMap.ATLAS_TEXTURE,
            values = {
                ["UI-HUD-UnitFrame-Target-PortraitOn-Type"] = "Default",
                ["_ItemUpgradeTooltip-NineSlice-EdgeBottom"] = "Bottom Glow",
                ["Interface/AddOns/BeaconUnitFrames/icons/underhighlight_mask.png"] = "Custom Bottom Glow",
            },
            get = function(info)
                return ns.db.profile.unitFrames.target.reputationBar.atlasTexture
            end,
            set = function(info, value)
                ns.db.profile.unitFrames.target.reputationBar.atlasTexture = value
                BUFTargetReputationBar:SetTexture()
            end,
        },
    },
}

repBar.args.texturing = {
    type = "header",
    name = ns.L["Texturing"],
    order = ns.defaultOrderMap.TEXTURING_HEADER,
}

ns.AddPositionableOptions(repBar.args)
ns.AddSizableOptions(repBar.args)
ns.AddColorOptions(repBar.args)
ns.AddClassColorOptions(repBar.args)
ns.AddReactionColorOptions(repBar.args)

ns.options.args.target.args.reputationBar = repBar

function BUFTargetReputationBar:RefreshConfig()
    self:SetSize()
    self:SetPosition()
    self:SetTexture()
    self:RefreshColor()
end

function BUFTargetReputationBar:SetSize()
    local repColorBar = ns.BUFTarget.contentMain.ReputationColor
    local width = ns.db.profile.unitFrames.target.reputationBar.width
    local height = ns.db.profile.unitFrames.target.reputationBar.height
    repColorBar:SetWidth(width)
    repColorBar:SetHeight(height)
end

function BUFTargetReputationBar:SetPosition()
    local repColorBar = ns.BUFTarget.contentMain.ReputationColor
    local xOffset = ns.db.profile.unitFrames.target.reputationBar.xOffset
    local yOffset = ns.db.profile.unitFrames.target.reputationBar.yOffset
    local point = ns.db.profile.unitFrames.target.reputationBar.anchorPoint
    local relativeTo = ns.db.profile.unitFrames.target.reputationBar.relativeTo
    local relativePoint = ns.db.profile.unitFrames.target.reputationBar.relativePoint
    repColorBar:ClearAllPoints()
    repColorBar:SetPoint(
        point,
        _G[relativeTo],
        relativePoint,
        xOffset,
        yOffset
    )
end

function BUFTargetReputationBar:SetTexture()
    local repColorBar = ns.BUFTarget.contentMain.ReputationColor
    local atlasTexture = ns.db.profile.unitFrames.target.reputationBar.atlasTexture
    local sPos, ePos = string.find(atlasTexture, "%.")
    if not sPos then
        repColorBar:SetAtlas(atlasTexture, false)
    else
        -- If there's a dot, it's a file path
        repColorBar:SetTexture(atlasTexture)
    end
end

function BUFTargetReputationBar:RefreshColor()
    local parent = ns.BUFTarget
    local repColorBar = ns.BUFTarget.contentMain.ReputationColor
    local useCustomColor = ns.db.profile.unitFrames.target.reputationBar.useCustomColor
    local useClassColor = ns.db.profile.unitFrames.target.reputationBar.useClassColor
    local useReactionColor = ns.db.profile.unitFrames.target.reputationBar.useReactionColor

    if parent:IsHooked(repColorBar, "SetVertexColor") then
        parent:Unhook(repColorBar, "SetVertexColor")
    end
    local r, g, b, a = nil, nil, nil, 1
    if useCustomColor then
        r, g, b, a = unpack(ns.db.profile.unitFrames.target.reputationBar.customColor)
    elseif useClassColor and (not useReactionColor or UnitPlayerControlled("target")) then
        local _, class = UnitClass("target")
        r, g, b = GetClassColor(class)
    elseif useReactionColor then
        r, g, b = GameTooltip_UnitColor("target")
    else
        return
    end
    
    repColorBar:SetVertexColor(r, g, b, a)
    parent:SecureHook(repColorBar, "SetVertexColor", function(s, r, g, b, a)
        self:RefreshColor()
    end)
end
