--@strip-comments@
---@type string, table
local _, ns = ...

---@class BUFNamespace
ns = ns

local L = LibStub("AceLocale-3.0"):NewLocale(ns.localeName, "koKR")
if not L then
	return
end

--- Place newest translations/locale keys at the top, wrapped in --#region and --#endregion for the version number that they were added in.
--- You may translate these comments, but do not translate "region" or "endregion" as they are used by the localization tool to determine where to place the translations.
--- To add translations, simply uncomment the line(s) and replace the English text after the equal sign (=) with the translated value.

--#region v1.0.0
--#endregion
