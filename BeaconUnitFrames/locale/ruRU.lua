---@type string, table
local _, ns = ...

---@class BUFNamespace
ns = ns

local L = LibStub("AceLocale-3.0"):NewLocale(ns.localeName, "ruRU")
if not L then
	return
end

--- Place newest translations/locale keys at the top, wrapped in --#region and --#endregion for the version number that they were added in.
--- You may translate these comments, but do not translate "region" or "endregion" as they are used by the localization tool to determine where to place the translations.
--- To add translations, simply uncomment the line(s) and replace the English text after the equal sign (=) with the translated value.

--#region v1.0.0
-- L["Background Texture"] = "Background Texture"
-- L["Coming Soon"] = "Coming Soon"
-- L["Custom Color"] = "Custom Color"
-- L["EnablePlayerPortrait"] = "Enable or disable the player's portrait on the unit frame."
-- L["Font Color"] = "Font Color"
-- L["Font Face"] = "Font Face"
-- L["Font Flags"] = "Font Flags"
-- L["Font Object"] = "Font Object"
-- L["FontObjectDesc"] = "Select the font object to use for the player's name."
-- L["Foreground"] = "Foreground"
-- L["Frame"] = "Frame"
-- L["Frame Level"] = "Frame Level"
-- L["Monochrome"] = "Monochrome"
-- L["Portrait"] = "Portrait"
-- L["Show/Hide Minimap Icon"] = "Show/Hide Minimap Icon"
-- L["Status Bar Texture"] = "Status Bar Texture"
-- L["Thick Outline"] = "Thick Outline"
-- L["Use Background Texture"] = "Use Background Texture"
-- L["Use Class Color"] = "Use Class Color"
-- L["Use Custom Color"] = "Use Custom Color"
-- L["Use Font Objects"] = "Use Font Objects"
-- L["Use Full Frame Width"] = "Use Full Frame Width"
-- L["Use Status Bar Texture"] = "Use Status Bar Texture"
-- L["UseBackgroundTextureDesc"] = "When enabled, the selected background texture will be applied to the health bar."
-- L["UseClassColorDesc"] = "When enabled, the health bar will use the player's class color."
-- L["UseCustomColorDesc"] = "When enabled, a custom color can be set for the health bar."
-- L["UseFontObjectsDesc"] = "If enabled, the font face, size, and flags options will be disabled and the selected font object will be used instead."
-- L["UseFullPlayerFrameWidthDesc"] = "When enabled, the health and resource bars will stretch the full width of the player frame, hiding the portrait."
-- L["UseStatusBarTextureDesc"] = "When enabled, the selected status bar texture will be applied to the health bar."
-- L["X Offset"] = "X Offset"
-- L["Y Offset"] = "Y Offset"
--#endregion
