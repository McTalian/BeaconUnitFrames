---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.ClassResources: BUFConfigHandler, Positionable
local BUFPlayerClassResources = {
    configPath = "unitFrames.player.classResources",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerClassResources)

BUFPlayer.ClassResources = BUFPlayerClassResources

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.ClassResources
ns.dbDefaults.profile.unitFrames.player.classResources = {
    xOffset = 30,
    yOffset = 25,
}

local classResources = {
    type = "group",
    handler = BUFPlayerClassResources,
    name = ns.L["ClassResources"],
    order = BUFPlayer.optionsOrder.CLASS_RESOURCES,
    args = {}
}

ns.AddPositionableOptions(classResources.args)

ns.options.args.unitFrames.args.player.args.classResources = classResources

function BUFPlayerClassResources:RefreshConfig()
    self:SetPosition()
end

function BUFPlayerClassResources:SetPosition()
    local xOffset = ns.db.profile.unitFrames.player.classResources.xOffset
    local yOffset = ns.db.profile.unitFrames.player.classResources.yOffset
    local bottomFrame = PlayerFrameBottomManagedFramesContainer

    bottomFrame:SetPoint("TOP", PlayerFrame, "BOTTOM", xOffset, yOffset)
end
