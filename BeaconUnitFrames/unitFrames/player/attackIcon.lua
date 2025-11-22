---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.AttackIcon: BUFConfigHandler, Positionable, Sizable, Demoable
local BUFPlayerAttackIcon = {
    configPath = "unitFrames.player.attackIcon",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerAttackIcon)
ns.ApplyMixin(ns.Sizable, BUFPlayerAttackIcon)
ns.ApplyMixin(ns.Demoable, BUFPlayerAttackIcon)

BUFPlayer.AttackIcon = BUFPlayerAttackIcon

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

local attackIconOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    USE_ATLAS_SIZE = 3,
    WIDTH = 4,
    HEIGHT = 5,
}

local attackIcon = {
    type = "group",
    handler = BUFPlayerAttackIcon,
    name = ns.L["Attack Icon"],
    order = BUFPlayer.optionsOrder.ATTACK_ICON,
    args = {
        useAtlasSize = {
            type = "toggle",
            name = ns.L["UseAtlasSize"],
            desc = ns.L["UseAtlasSizeDesc"],
            set = function(info, value)
                ns.db.profile.unitFrames.player.attackIcon.useAtlasSize = value
                BUFPlayerAttackIcon:SetSize()
            end,
            get = function(info)
                return ns.db.profile.unitFrames.player.attackIcon.useAtlasSize
            end,
            order = attackIconOrder.USE_ATLAS_SIZE,
        },
    },
}

ns.AddPositioningOptions(attackIcon.args, attackIconOrder)
ns.AddSizingOptions(attackIcon.args, attackIconOrder)
ns.AddDemoOptions(attackIcon.args, attackIconOrder)

ns.options.args.unitFrames.args.player.args.attackIcon = attackIcon

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

