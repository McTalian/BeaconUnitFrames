---
applyTo: "BeaconUnitFrames/core/**"
---

## Initialization Order
`core.lua` bootstraps the addon in `BUF:OnInitialize()`:
```
DbManager:Initialize()       -- creates ns.db via AceDB-3.0
OptionsManager:Initialize()  -- registers Ace3 config tree
BrokerManager:Initialize()   -- creates minimap icon + LDB launcher
```
`PLAYER_ENTERING_WORLD` (fired on login and reload) is the earliest safe point to call `RefreshConfig` — WoW frames are not yet guaranteed valid during `OnInitialize`. The event also registers the Blizzard options panel (`ns.acd:AddToBlizOptions`) on first fire.

## DB Schema (`db.lua`)
`ns.dbDefaults` defines the AceDB schema. The `dbName` field (`"BUFDB"`) **must match the `## SavedVariables: BUFDB` line in the TOC file** — a mismatch silently creates a new, empty DB on each login.

```
ns.db.global
  .lastVersionLoaded   string   -- @project-version@ of last loaded release
  .minimap.hide        boolean  -- minimap icon visibility (true = hidden)
  .restoreCvars        table    -- CVars to restore (keyed by CVar name)

ns.db.profile
  .unitFrames          table    -- all per-unit-frame config (populated by feature modules)
```
- `global` scope persists across all characters and profiles.
- `profile` scope is per-character-profile and is what all feature module `configPath` keys resolve into.
- Feature modules declare their slice of the schema by assigning `ns.dbDefaults.profile.unitFrames.<frame>.<component> = MyModule.dbDefaults` before `AceDB-3.0:New(...)` is called. `DbManager:Initialize()` is the last moment defaults can be expanded.

## DB Access Layers (`dbHandler.lua`)
Two handler bases are provided — never access `ns.db` directly in feature modules:

| Handler | `dbKey` | Resolves into |
|---|---|---|
| `ns.ProfileDbBackedHandler` | `"profile"` | `ns.db.profile.<configPath>.<key>` |
| `ns.GlobalDbBackedHandler` | `"global"` | `ns.db.global.<configPath>.<key>` |

`DbGet`/`DbSet`/`DbClear` parse dotted `configPath + "." + key` strings. Numeric path segments (e.g. `"frames.1.health"`) are automatically converted to integer table keys.

`DbClear(nil)` (no key argument) wipes the entire `configPath` subtree, resetting it to defaults — used by "Reset to Defaults" option controls.

## Version Tracking
`ns.addonVersion` holds the `@project-version@` build token (resolved at package time; reads `"@project-version@"` literally in dev builds). On `PLAYER_ENTERING_WORLD` for a login (not reload), if `addonVersion ~= db.global.lastVersionLoaded`, the new version is saved. Feature modules can compare these to trigger first-run migration logic or changelog popups.

## RefreshConfig Cascade
```
BUF:RefreshConfig()
  └─ ns.BUFUnitFrames:RefreshConfig()
       └─ (each registered frame):RefreshConfig()
```
All frame state updates flow through `RefreshConfig`. Never call `SetWidth`, `SetFont`, etc. directly outside of `RefreshConfig` or a mixin set/get handler — always re-enter through `RefreshConfig` or the relevant sub-method so DB state remains the source of truth.

## Broker & Minimap (`broker.lua`)
`BrokerManager` creates a `LibDataBroker-1.1` launcher object and registers it with `LibDBIcon-1.0`:
- **Left-click** → opens the Ace3 config dialog (`ns.acd:Open(addonName)`)
- **Right-click** → opens a `LibEasyMenu` context menu
- Minimap visibility is toggled via `ns.db.global.minimap.hide` and `LibDBIcon:Show/Hide`

`brokerIconLib:AddButtonToCompartment(addonName)` also pins the icon to the addon compartment (top-right button tray). The minimap state table (`ns.db.global.minimap`) is passed by reference to `LibDBIcon:Register`, so any external library that reads it stays in sync.

## Shared Utilities

- `ns.acd` — `AceConfigDialog-3.0` instance; use to open the options panel programmatically.
- `ns.TableToCommaSeparatedString(tbl)` — debug helper that serializes a `{key=true}` boolean table to a comma-separated string.
