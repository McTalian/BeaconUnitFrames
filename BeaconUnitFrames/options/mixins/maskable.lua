---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class MaskableBaseHandler: BUFConfigHandler
---@field RefreshMask fun(self: MaskableBaseHandler)

---@class MaskableBase: MaskableBaseHandler
local MaskableBase = {}

function MaskableBase:SetMask(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".mask", value)
    self:RefreshMask()
end

function MaskableBase:GetMask(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".mask")
end

function MaskableBase:SetMaskWidthScale(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".maskWidthScale", value)
    self:RefreshMask()
end

function MaskableBase:GetMaskWidthScale(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".maskWidthScale")
end

function MaskableBase:SetMaskHeightScale(info, value)
    ns.DbUtils.setPath(ns.db.profile, self.configPath .. ".maskHeightScale", value)
    self:RefreshMask()
end

function MaskableBase:GetMaskHeightScale(info)
    return ns.DbUtils.getPath(ns.db.profile, self.configPath .. ".maskHeightScale")
end

function MaskableBase:_RefreshMask(maskTexture)
    local maskPath = self:GetMask()

    local sPos, ePos = string.find(maskPath, "%.")
    local isTexture = sPos ~= nil
    if isTexture then
        -- File path
        maskTexture:SetTexture(maskPath)
    else
        -- Atlas
        maskTexture:SetAtlas(maskPath, false)
    end
end

local function BoxMaskOptionValues()
    return {
        ["ui-hud-unitframe-player-portrait-mask"] = ns.L["PlayerPortraitShape"],
        ["CircleMaskScalable"] = ns.L["CircleShape"],
        ["squaremask"] = ns.L["SquareShape"],
        ["interface/widgets/dragonridingsgvigorwidgetmask.blp"] = ns.L["DiamondShape"],
        ["Interface/AddOns/BeaconUnitFrames/icons/hexagon_mask_point.png"] = ns.L["HexagonShape"],
        ["Interface/AddOns/BeaconUnitFrames/icons/hexagon_mask_flat.png"] = ns.L["FlatTopHexagonShape"],
    }
end

--- Add box maskable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddBoxMaskableOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.texturing = optionsTable.texturing or {
        type = "header",
        name = ns.L["Texturing"],
        order = orderMap.TEXTURING_HEADER,
    }

    optionsTable.mask = {
        type = "select",
        name = ns.L["Mask"],
        desc = ns.L["MaskDesc"],
        values = BoxMaskOptionValues,
        set = "SetMask",
        get = "GetMask",
        order = orderMap.MASK,
    }

    optionsTable.maskWidthScale = {
        type = "range",
        name = ns.L["Mask Width Scale"],
        desc = ns.L["Mask Width Scale Desc"],
        min = 0,
        isPercent = true,
        max = 2,
        step = 0.001,
        bigStep = 0.05,
        set = "SetMaskWidthScale",
        get = "GetMaskWidthScale",
        order = orderMap.MASK_WIDTH_SCALE,
    }

    optionsTable.maskHeightScale = {
        type = "range",
        name = ns.L["Mask Height Scale"],
        desc = ns.L["Mask Height Scale Desc"],
        isPercent = true,
        min = 0,
        max = 2,
        step = 0.001,
        bigStep = 0.05,
        set = "SetMaskHeightScale",
        get = "GetMaskHeightScale",
        order = orderMap.MASK_HEIGHT_SCALE,
    }
end

---@class BoxMaskableHandler: BUFConfigHandler, MaskableBase

---@class BoxMaskable: BoxMaskableHandler
local BoxMaskable = {}

ns.Mixin(BoxMaskable, MaskableBase)

ns.BoxMaskable = BoxMaskable
