---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.AttackIcon: BUFConfigHandler, Positionable, AtlasSizable, Demoable
local BUFPlayerAttackIcon = {
    configPath = "unitFrames.player.attackIcon",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerAttackIcon)
ns.ApplyMixin(ns.AtlasSizable, BUFPlayerAttackIcon)
ns.ApplyMixin(ns.Demoable, BUFPlayerAttackIcon)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.AttackIcon
ns.dbDefaults.profile.unitFrames.player.attackIcon = {
    xOffset = 64,
    yOffset = -62,
    useAtlasSize = true,
    width = 16,
    height = 16,
}

local attackIcon = {
    type = "group",
    handler = BUFPlayerAttackIcon,
    name = ns.L["Attack Icon"],
    order = BUFPlayerIndicators.optionsOrder.ATTACK_ICON,
    args = {},
}

ns.AddPositionableOptions(attackIcon.args)
ns.AddAtlasSizableOptions(attackIcon.args)
ns.AddDemoOptions(attackIcon.args)

ns.options.args.unitFrames.args.player.args.indicators.args.attackIcon = attackIcon

local ATTACK_ICON_ATLAS = "UI-HUD-UnitFrame-Player-CombatIcon"

function BUFPlayerAttackIcon:ToggleDemoMode()
    local attackIcon = BUFPlayer.contentContextual.AttackIcon
    if self.demoMode then
        self.demoMode = false
        attackIcon:Hide()
    else
        self.demoMode = true
        attackIcon:Show()
    end
end

function BUFPlayerAttackIcon:RefreshConfig()
    self:SetPosition()
    self:SetSize()
end

function BUFPlayerAttackIcon:SetPosition()
    local attackIcon = BUFPlayer.contentContextual.AttackIcon
    local xOffset = ns.db.profile.unitFrames.player.attackIcon.xOffset
    local yOffset = ns.db.profile.unitFrames.player.attackIcon.yOffset
    attackIcon:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerAttackIcon:SetSize()
    local attackIcon = BUFPlayer.contentContextual.AttackIcon
    local useAtlasSize = ns.db.profile.unitFrames.player.attackIcon.useAtlasSize
    local width = ns.db.profile.unitFrames.player.attackIcon.width
    local height = ns.db.profile.unitFrames.player.attackIcon.height

    if useAtlasSize then
        attackIcon:SetAtlas(ATTACK_ICON_ATLAS, true)
    else
        attackIcon:SetAtlas(ATTACK_ICON_ATLAS, false)
        attackIcon:SetWidth(width)
        attackIcon:SetHeight(height)
    end
end

BUFPlayerIndicators.AttackIcon = BUFPlayerAttackIcon
