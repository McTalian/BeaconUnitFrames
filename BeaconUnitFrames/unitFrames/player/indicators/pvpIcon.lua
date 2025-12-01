---@class BUFNamespace
local ns = select(2, ...)

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

BUFPlayerPvPIcon.dbDefaults = {
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = "TOPRIGHT",
    xOffset = 25,
    yOffset = -50,
    scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFPlayerPvPIcon)

BUFPlayerIndicators.PvPIcon = BUFPlayerPvPIcon

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player
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
      self.defaultRelativeTo = BUFPlayer.contentContextual
  end
  self:RefreshScaleTextureConfig()
end
