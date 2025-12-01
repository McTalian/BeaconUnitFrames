---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.PvPIcon: BUFScaleTexture
local BUFTargetPvPIcon = {
    configPath = "unitFrames.target.pvpIcon",
}

BUFTargetPvPIcon.optionsTable = {
    type = "group",
    handler = BUFTargetPvPIcon,
    name = ns.L["PvP Icon"],
    order = BUFTargetIndicators.optionsOrder.PVP_ICON,
    args = {},
}

---@class BUFDbSchema.UF.Target.PvPIcon
BUFTargetPvPIcon.dbDefaults = {
    anchorPoint = "TOP",
    relativeTo = ns.DEFAULT,
    relativePoint = "TOPRIGHT",
    xOffset = -26,
    yOffset = -50,
    scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetPvPIcon)

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.pvpIcon = BUFTargetPvPIcon.dbDefaults

ns.options.args.target.args.indicators.args.pvpIcon = BUFTargetPvPIcon.optionsTable

function BUFTargetPvPIcon:ToggleDemoMode()
    self:_ToggleDemoMode(self.texture)
    if self.demoMode then
        local factionGroup, _ = UnitFactionGroup("target");
        if factionGroup ~= "Horde" and factionGroup ~= "Alliance" then
            factionGroup = "FFA"
        end
        local iconSuffix = string.lower(factionGroup) .. "icon"
        self.texture:SetAtlas("ui-hud-unitframe-player-pvp-" .. iconSuffix, true)
    end
end

function BUFTargetPvPIcon:RefreshConfig()
  if not self.texture then
      self.texture = BUFTarget.contentContextual.PvpIcon
      self.defaultRelativeTo = BUFTarget.contentContextual
  end
  self:RefreshScaleTextureConfig()
end

BUFTargetIndicators.PvPIcon = BUFTargetPvPIcon
