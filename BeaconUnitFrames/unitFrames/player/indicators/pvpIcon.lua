---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.PvPIcon: BUFConfigHandler, Positionable, AtlasScalable, Demoable
local BUFPlayerPvPIcon = {
    configPath = "unitFrames.player.pvpIcon",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerPvPIcon)
ns.ApplyMixin(ns.AtlasScalable, BUFPlayerPvPIcon)
ns.ApplyMixin(ns.Demoable, BUFPlayerPvPIcon)

BUFPlayerIndicators.PvPIcon = BUFPlayerPvPIcon

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.PvPIcon
ns.dbDefaults.profile.unitFrames.player.pvpIcon = {
    xOffset = 25,
    yOffset = -50,
    useAtlasSize = true,
    scale = 1.0,
}

local pvpIcon = {
    type = "group",
    handler = BUFPlayerPvPIcon,
    name = ns.L["PvP Icon"],
    order = BUFPlayerIndicators.optionsOrder.PVP_ICON,
    args = {},
}

ns.AddPositionableOptions(pvpIcon.args)
ns.AddAtlasScalableOptions(pvpIcon.args)
ns.AddDemoOptions(pvpIcon.args)

ns.options.args.unitFrames.args.player.args.indicators.args.pvpIcon = pvpIcon

function BUFPlayerPvPIcon:ToggleDemoMode()
    local pvpIcon = BUFPlayer.contentContextual.PVPIcon
    local factionGroup, factionName = UnitFactionGroup("player");
    if factionGroup ~= "Horde" and factionGroup ~= "Alliance" then
        factionGroup = "FFA"
    end
    local iconSuffix = string.lower(factionGroup) .. "icon"
    if self.demoMode then
        self.demoMode = false
        pvpIcon:Hide()
    else
        self.demoMode = true
        pvpIcon:SetAtlas("ui-hud-unitframe-player-pvp-" .. iconSuffix, true)
        pvpIcon:Show()
    end
end

function BUFPlayerPvPIcon:RefreshConfig()
  self:SetPosition()
  self:SetScaleFactor()
end

function BUFPlayerPvPIcon:SetPosition()
    local pvpIcon = BUFPlayer.contentContextual.PVPIcon
    local db = ns.db.profile.unitFrames.player.pvpIcon
    pvpIcon:ClearAllPoints()
    pvpIcon:SetPoint("TOP", BUFPlayer.contentContextual, "TOPLEFT", db.xOffset, db.yOffset)
end

function BUFPlayerPvPIcon:SetScaleFactor()
    local pvpIcon = BUFPlayer.contentContextual.PVPIcon
    local scale = ns.db.profile.unitFrames.player.pvpIcon.scale
    pvpIcon:SetScale(scale)
end
