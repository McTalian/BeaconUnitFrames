---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.AttackIcon: BUFConfigHandler, BUFTexture
local BUFPlayerAttackIcon = {
    configPath = "unitFrames.player.attackIcon",
}

BUFPlayerAttackIcon.optionsTable = {
    type = "group",
    handler = BUFPlayerAttackIcon,
    name = ns.L["Attack Icon"],
    order = BUFPlayerIndicators.optionsOrder.ATTACK_ICON,
    args = {},
}

ns.BUFTexture:ApplyMixin(BUFPlayerAttackIcon)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.AttackIcon
ns.dbDefaults.profile.unitFrames.player.attackIcon = {
    anchorPoint = "TOPLEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 64,
    yOffset = -62,
    useAtlasSize = true,
    width = 16,
    height = 16,
    scale = 1,
}

ns.options.args.unitFrames.args.player.args.indicators.args.attackIcon = BUFPlayerAttackIcon.optionsTable

local ATTACK_ICON_ATLAS = "UI-HUD-UnitFrame-Player-CombatIcon"

function BUFPlayerAttackIcon:RefreshConfig()
    if not self.texture then
        self.texture = BUFPlayer.contentContextual.AttackIcon
        self.atlasName = ATTACK_ICON_ATLAS
        self.defaultRelativeTo = BUFPlayer.contentContextual
        self.defaultRelativePoint = "TOPLEFT"
    end
    self:RefreshTextureConfig()
end

BUFPlayerIndicators.AttackIcon = BUFPlayerAttackIcon
