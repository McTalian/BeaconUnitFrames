---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.RoleIcon: BUFConfigHandler, Positionable, Sizable, Demoable
local BUFPlayerRoleIcon = {
    configPath = "unitFrames.player.roleIcon",
}

ns.ApplyMixin(ns.Positionable, BUFPlayerRoleIcon)
ns.ApplyMixin(ns.Sizable, BUFPlayerRoleIcon)
ns.ApplyMixin(ns.Demoable, BUFPlayerRoleIcon)

BUFPlayerIndicators.RoleIcon = BUFPlayerRoleIcon

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

---@class BUFDbSchema.UF.Player.RoleIcon
ns.dbDefaults.profile.unitFrames.player.roleIcon = {
    xOffset = 196,
    yOffset = -27,
    width = 12,
    height = 12,
}

local roleIconOrder = {
    DEMO_MODE = 0.5,
    X_OFFSET = 1,
    Y_OFFSET = 2,
    WIDTH = 3,
    HEIGHT = 4,
}

local roleIcon = {
    type = "group",
    handler = BUFPlayerRoleIcon,
    name = ns.L["Role Icon"],
    order = BUFPlayerIndicators.optionsOrder.ROLE_ICON,
    args = {},
}

ns.AddPositionableOptions(roleIcon.args, roleIconOrder)
ns.AddSizableOptions(roleIcon.args, roleIconOrder)
ns.AddDemoOptions(roleIcon.args, roleIconOrder)

ns.options.args.unitFrames.args.player.args.indicators.args.roleIcon = roleIcon

function BUFPlayerRoleIcon:ToggleDemoMode()
    local roleIcon = BUFPlayer.contentContextual.RoleIcon
    if self.demoMode then
        self.demoMode = false
        roleIcon:Hide()
    else
        self.demoMode = true
        roleIcon:Show()
    end
end

function BUFPlayerRoleIcon:RefreshConfig()
    self:SetPosition()
    self:SetSize()
end

function BUFPlayerRoleIcon:SetPosition()
    local roleIcon = BUFPlayer.contentContextual.RoleIcon
    local xOffset = ns.db.profile.unitFrames.player.roleIcon.xOffset
    local yOffset = ns.db.profile.unitFrames.player.roleIcon.yOffset
    roleIcon:ClearAllPoints()
    roleIcon:SetPoint("TOPLEFT", xOffset, yOffset)
end

function BUFPlayerRoleIcon:SetSize()
    local roleIcon = BUFPlayer.contentContextual.RoleIcon
    local width = ns.db.profile.unitFrames.player.roleIcon.width
    local height = ns.db.profile.unitFrames.player.roleIcon.height
    roleIcon:SetWidth(width)
    roleIcon:SetHeight(height)
end

