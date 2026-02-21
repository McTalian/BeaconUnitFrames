---
applyTo: "**/locale/**"
---

## File Loading Chain

Locale files load in three stages via `index.xml`:

1. `init.lua` — sets `ns.localeName = addonName .. "Locale"` before any locale files load
2. Per-language files — each calls `LibStub("AceLocale-3.0"):NewLocale(ns.localeName, "LOCALE"[, true])`
3. `load.lua` — exposes `ns.L = LibStub("AceLocale-3.0"):GetLocale(ns.localeName)` for use across the addon

Do not access `LibStub("AceLocale-3.0"):GetLocale(...)` directly in feature files — always use `ns.L`.

## Base vs. Non-Base Locales

`enUS.lua` and `enGB.lua` pass `true` as the third argument to `NewLocale`, making them the canonical fallback locales. All other locale files omit that argument and guard early-return:

```lua
local L = LibStub("AceLocale-3.0"):NewLocale(ns.localeName, "deDE")
if not L then return end
```

Non-base locales have untranslated keys commented out (`-- L["Key"] = "Value"`). AceLocale falls back to enUS for any missing key at runtime.

Non-base locale files also begin with `--@strip-comments@` so the `wow-build-tools` packager strips the comment block in release builds.

## Versioned Region Blocks

All keys are wrapped in `--#region vX.Y.Z` / `--#endregion` blocks. **Newest version block goes at the top of the file**, above older version blocks:

```lua
--#region v1.2.0        -- newest at top
L["NewKey"] = "New Value"
--#endregion

--#region v1.1.0
L["OlderKey"] = "Older Value"
--#endregion
```

Do not translate the words `region` or `endregion` — the i18n tooling (`make i18n_fmt`) uses them to locate and insert new keys into non-base locale files.

## Adding a New Locale Key

1. Add the key assignment to `enUS.lua` and `enGB.lua` inside a `--#region vX.Y.Z` block matching the current release version (create the block if it does not yet exist).
2. In all other locale files, add the key **commented out** in the same version block:
   ```lua
   --#region v1.2.0
   -- L["NewKey"] = "New Value"
   --#endregion
   ```
3. Run `make i18n_check` to confirm no keys are missing across locales.
4. Run `make i18n_fmt` to auto-sort and normalize all locale files.

The `@localization@` build token in `.pkgmeta` handles CurseForge localization import automatically during release packaging — do not manually duplicate keys for that purpose.

## Naming Conventions

- Keys that are displayed verbatim in the UI use the display string as the key (e.g. `L["Font Color"] = "Font Color"`).
- Keys that are long sentences or contain punctuation characters use a short camelCase identifier (e.g. `L["UseCustomColorDesc"] = "When enabled..."`).
- Anchor point names reuse Blizzard globals as keys (`L["TOPLEFT"] = "TOPLEFT"`) so UI dropdown labels are localized when the global differs per locale.
