---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.PvPIcon: BUFScaleTexture
local BUFPlayerPvPIcon = {
    configPath = "unitFrames.player.pvpIcon",
}

BUFPlayerPvPIcon.optionsTable = {
    type = "group",
    handler = BUFPlayerPvPIcon,
    name = ns.L["PvP Icon"],
    order = BUFPlayerIndicators.optionsOrder.PVP_ICON,
    args = {},
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerPvPIcon)

BUFPlayerIndicators.PvPIcon = BUFPlayerPvPIcon

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.PvPIcon
ns.dbDefaults.profile.unitFrames.player.pvpIcon = {
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 25,
    yOffset = -50,
    useAtlasSize = true,
    scale = 1.0,
}


-- We will always use the atlas size for the PvP icon
-- since the icon is dynamic and they all have different sizes.
-- We will rely on scaling to adjust size instead.
BUFPlayerPvPIcon.optionsTable.args.useAtlasSize = nil

ns.options.args.player.args.indicators.args.pvpIcon = BUFPlayerPvPIcon.optionsTable

function BUFPlayerPvPIcon:ToggleDemoMode()
    self:_ToggleDemoMode(self.texture)
    if self.demoMode then
        local factionGroup, _ = UnitFactionGroup("player");
        if factionGroup ~= "Horde" and factionGroup ~= "Alliance" then
            factionGroup = "FFA"
        end
        local iconSuffix = string.lower(factionGroup) .. "icon"
        self.texture:SetAtlas("ui-hud-unitframe-player-pvp-" .. iconSuffix, true)
    end
end

function BUFPlayerPvPIcon:RefreshConfig()
  if not self.texture then
      self.texture = BUFPlayer.contentContextual.PVPIcon
      self.atlasName = "UI-HUD-UnitFrame-Player-PvP-FFAIcon"
      self.defaultRelativeTo = BUFPlayer.contentContextual
      self.defaultRelativePoint = "TOPRIGHT"
  end
  self:RefreshScaleTextureConfig()
end
