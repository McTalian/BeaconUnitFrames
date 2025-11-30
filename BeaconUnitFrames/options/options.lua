---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.DEFAULT = "BUF_IGNORE_DEFAULT"

---@class BUFOptionsOrder
ns.defaultOrderMap = {
    DEMO_MODE = 1,
    ENABLE = 2,
    SIZING_HEADER = 2.5,
    USE_ATLAS_SIZE = 3,
    WIDTH = 4,
    HEIGHT = 5,
    SCALE = 5.5,
    POSITIONING_HEADER = 5.9,
    ANCHOR_POINT = 6,
    RELATIVE_TO = 7,
    RELATIVE_POINT = 8,
    X_OFFSET = 9,
    Y_OFFSET = 10,
    FRAME_LEVEL = 11,
    CUSTOMIZATION_HEADER = 11.9,
    CUSTOM_TEXT = 12,
    JUSTIFY_H = 12.2,
    JUSTIFY_V = 12.4,
    FONT_SETTINGS_HEADER = 12.9,
    USE_FONT_OBJECTS = 13,
    FONT_OBJECT = 14,
    FONT_COLOR = 15,
    FONT_FACE = 16,
    FONT_SIZE = 17,
    FONT_FLAGS = 18,
    FONT_SHADOW_COLOR = 19,
    FONT_SHADOW_OFFSET_X = 20,
    FONT_SHADOW_OFFSET_Y = 21,
    TEXTURING_HEADER = 21.9,
    ATLAS_TEXTURE = 24,
    MASK = 24.1,
    MASK_WIDTH_SCALE = 24.2,
    MASK_HEIGHT_SCALE = 24.3,
    STATUS_BAR_HEADER = 24.9,
    USE_STATUS_BAR_TEXTURE = 25,
    STATUS_BAR_TEXTURE = 26,
    BACKGROUND_HEADER = 26.9,
    USE_BACKGROUND_TEXTURE = 27,
    BACKGROUND_TEXTURE = 28,
    COLORING_HEADER = 28.9,
    USE_CUSTOM_COLOR = 29,
    CUSTOM_COLOR = 30,
    CLASS_COLOR = 31,
    POWER_COLOR = 32,
    REACTION_COLOR = 33,
}

ns.OptionsManager = {}

function ns.OptionsManager:Initialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, ns.options)
    ns.acd:SetDefaultSize(addonName, 650, 800)
end

---@class BUFOptions: AceConfig.OptionsTable
ns.options = {
    name = OPTIONS_MENU,
    type = "group",
    childGroups = "select",
    args = {},
}
