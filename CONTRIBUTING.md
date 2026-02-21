# BeaconUnitFrames Contributor Guide

Welcome! This guide explains how BeaconUnitFrames works under the hood, the code flow, directory structure, and how it differs from oUF-style addons.

## Table of Contents

1. [High-Level Overview](#high-level-overview)
2. [Directory Structure](#directory-structure)
3. [Code Flow & Initialization](#code-flow--initialization)
4. [Feature Module Pattern](#feature-module-pattern)
5. [Unit Frame Architecture](#unit-frame-architecture)
6. [How Skinning Works (vs oUF)](#how-skinning-works-vs-ouf)
7. [Making Your First Change](#making-your-first-change)

---

## High-Level Overview

**BeaconUnitFrames (BUF)** is a WoW addon that **modifies and skins Blizzard's default unit frames** rather than replacing them. Unlike oUF, which creates entirely new frames from scratch, BUF:

- **Hooks into existing Blizzard frames** (`PlayerFrame`, `TargetFrame`, etc.)
- **Reskins and repositions** their sub-components (health bars, portraits, names, etc.)
- Uses **Ace3 framework** for addon structure, config management, and options UI
- **Stores configuration in a database** (AceDB) and applies it via `RefreshConfig()` cascades

**Key Difference from oUF:**

- **oUF**: Creates new frames, you write a layout file that spawns custom frames
- **BUF**: Modifies existing frames, you write feature modules that skin/reposition Blizzard's frames

---

## Directory Structure

```plain text
BeaconUnitFrames/
├── core/                          # Addon bootstrap & database management
│   ├── core.lua                   # Entry point: OnInitialize, PLAYER_ENTERING_WORLD
│   ├── db.lua                     # Database schema (ns.dbDefaults)
│   ├── dbHandler.lua              # DbGet/DbSet/DbClear abstraction
│   └── broker.lua                 # Minimap icon & LDB launcher
│
├── locale/                        # Localization strings (ns.L["Key"])
│   ├── init.lua                   # Sets up LibStub("AceLocale-3.0")
│   ├── enUS.lua, enGB.lua, ...    # Translation files per locale
│   └── load.lua                   # Loads locale at runtime
│
├── options/                       # Options UI & reusable behaviors
│   ├── options.lua                # Ace3 config tree setup, ns.NewFeatureModule()
│   ├── mixin.lua                  # Base mixin (ns.MixinBase)
│   ├── mixins/                    # Reusable option behaviors
│   │   ├── sizable.lua            # Width/height controls
│   │   ├── positionable.lua       # Anchor point/offset controls
│   │   ├── colorable.lua          # Color pickers
│   │   ├── fontable.lua           # Font/size/shadow controls
│   │   └── ...                    # Many more (see directory)
│   └── typeDefaults/              # Composite abstractions
│       ├── fontString.lua         # BUFFontString (Name, Level, StatusBar text)
│       ├── statusBar.lua          # BUFStatusBar (Health bar, Power bar)
│       └── texture.lua            # BUFTexture (Portrait, backgrounds)
│
└── unitFrames/                    # Unit frame implementations
    ├── unitFrames.lua             # RegisterFrame(), RefreshConfig() cascade
    ├── player/                    # PlayerFrame modifications
    │   ├── player.lua             # Top-level module (BUFPlayer)
    │   ├── frame/                 # Main frame container
    │   ├── portrait/              # Portrait texture
    │   ├── name/                  # Name fontString
    │   ├── level/                 # Level fontString
    │   ├── health/                # Health bar + text
    │   ├── power/                 # Power bar + text
    │   ├── indicators/            # Status icons (rest, combat, etc.)
    │   └── ...
    ├── target/                    # TargetFrame (same structure as player/)
    ├── pet/, focus/, boss/, ...   # Other frame types
    └── index.xml                  # Loads all frame modules (order matters!)
```

### Key Directories Explained

- **`core/`** — Bootstraps the addon, initializes database, registers events
- **`options/`** — Defines the options UI structure and reusable behaviors (mixins)
- **`options/mixins/`** — Small, composable behaviors (sizing, positioning, coloring, etc.) that can be mixed into any handler
- **`options/typeDefaults/`** — Bundles of mixins + convenience methods for common component types (font strings, status bars, textures)
- **`unitFrames/`** — One subdirectory per unit frame type, each following the same internal structure (frame, portrait, name, health, power, indicators)

---

## Code Flow & Initialization

### 1. Addon Load Sequence

```plain text
WoW loads BeaconUnitFrames.toc
  ↓
Files loaded in order declared in index.xml files
  ↓
core/core.lua → BUF:OnInitialize()
  ├─ DbManager:Initialize()       # Create ns.db via AceDB
  ├─ OptionsManager:Initialize()  # Register Ace3 config tree
  └─ BrokerManager:Initialize()   # Create minimap icon
  ↓
Register event: PLAYER_ENTERING_WORLD
  ↓
PLAYER_ENTERING_WORLD fires (login or /reload)
  ├─ Register Blizzard options panel
  └─ BUF:RefreshConfig()
       ↓
     ns.BUFUnitFrames:RefreshConfig()
       ↓
     For each registered frame:
       frameModule:RefreshConfig()  # Apply all DB settings to WoW frames
```

### 2. First-Time Initialization (per module)

Each feature module has a `RefreshConfig()` method that:

1. **First call only:** Runs `FrameInit()` to set up `customRelativeToOptions` and cache frame references
2. **Every call:** Applies all DB settings to the cached WoW frames

```lua
function BUFPlayerName:RefreshConfig()
    -- First-time setup (runs once)
    if not self.initialized then
        BUFPlayer.FrameInit(self)  -- Copy parent's customRelativeToOptions
        self.fontString = PlayerName  -- Cache WoW frame reference
        self.initialized = true
    end

    -- Always runs: apply current DB settings
    if not self:DbGet("enabled") then
        self.fontString:Hide()
        return
    end

    self.fontString:Show()
    self:RefreshFontStringConfig()  -- Calls SetPosition/SetSize/SetFont/etc.
end
```

### 3. Configuration Flow

**All state lives in the database.** Never directly call `SetWidth()`, `SetFont()`, etc. outside of a `RefreshConfig` path. The flow is:

```plain text
User changes option in UI
  ↓
Option setter (e.g., SetWidth)
  ↓
DbSet("width", value)
  ↓
RefreshConfig()
  ↓
Read value via DbGet("width")
  ↓
Apply to WoW frame: frame:SetWidth(value)
```

This ensures the DB is always the **source of truth** and state is never out of sync.

---

## Feature Module Pattern

Every component in BUF is a **feature module** created via `ns.NewFeatureModule(name)`. This wraps Ace3's module system and automatically mixes in:

- `ProfileDbBackedHandler` — `DbGet`/`DbSet`/`DbClear` methods
- `AceHook-3.0` — Hook Blizzard functions without tainting
- `AceEvent-3.0` — Register/Unregister WoW events

### Anatomy of a Feature Module

```lua
---@class BUFPlayerName: BUFFeatureModule
local BUFPlayerName = ns.NewFeatureModule("BUFPlayerName")

-- 1. Database path (where config is stored)
BUFPlayerName.configPath = "unitFrames.player.name"

-- 2. Default values
BUFPlayerName.dbDefaults = {
    enabled = true,
    width = 120,
    height = 15,
    -- ...
}

-- 3. Register defaults with the global schema
ns.dbDefaults.profile.unitFrames.player.name = BUFPlayerName.dbDefaults

-- 4. Options table (Ace3 config)
BUFPlayerName.optionsTable = {
    type = "group",
    name = ns.L["Name"],
    handler = BUFPlayerName,
    args = {
        enable = {
            type = "toggle",
            name = ENABLE,
            get = "GetEnabled",
            set = "SetEnabled",
            order = 1,
        },
        -- ... more options
    },
}

-- 5. Register options with parent
ns.options.args.player.args.name = BUFPlayerName.optionsTable

-- 6. RefreshConfig (REQUIRED, errors if missing)
function BUFPlayerName:RefreshConfig()
    if not self.initialized then
        BUFPlayer.FrameInit(self)  -- One-time setup
        self.fontString = PlayerFrame.name  -- Cache frame reference
        self.initialized = true
    end

    -- Apply all settings from DB to WoW frame
    if not self:DbGet("enabled") then
        self.fontString:Hide()
        return
    end
    self.fontString:Show()
    self:SetFont()      -- Reads DB, applies font settings
    self:SetPosition()  -- Reads DB, applies position
    -- ...
end

-- 7. Register with parent (for top-level frames only)
ns.BUFUnitFrames:RegisterFrame(BUFPlayerName)
```

### Database Access

**Never access `ns.db` directly!** Use the handler methods:

```lua
-- Read a value
local width = self:DbGet("width")  -- Reads ns.db.profile.unitFrames.player.name.width

-- Write a value
self:DbSet("width", 150)           -- Writes to ns.db.profile.unitFrames.player.name.width

-- Reset to default
self:DbClear("width")              -- Resets to BUFPlayerName.dbDefaults.width

-- Reset entire module config
self:DbClear(nil)                  -- Resets all keys in unitFrames.player.name
```

Keys are relative to `configPath` and use dotted notation. Numeric segments (e.g., `"frames.1.health"`) are automatically converted to integer table indices.

---

## Unit Frame Architecture

### Single-Instance Frames (Player, Target, Pet, Focus, etc.)

These manage **one WoW frame**. Structure:

```plain text
BUFPlayer (top-level module)
  ├─ BUFPlayerFrame         # Main container positioning
  ├─ BUFPlayerPortrait      # Portrait texture
  ├─ BUFPlayerName          # Name fontString
  ├─ BUFPlayerLevel         # Level fontString
  ├─ BUFPlayerHealth        # Health bar container
  │    ├─ BUFPlayerHealthBar        # Status bar itself
  │    └─ BUFPlayerHealthText       # Text overlay
  ├─ BUFPlayerPower         # Power bar container
  │    ├─ BUFPlayerPowerBar
  │    └─ BUFPlayerPowerText
  └─ BUFPlayerIndicators    # Status icons (rest, combat, leader, etc.)
```

Each sub-component is a separate feature module with its own `RefreshConfig()`.

### Multi-Instance Frames (Boss, Party)

These manage **multiple WoW frames** (up to 5 bosses, 4 party members). Structure:

```plain text
BUFBoss (top-level module)
  └─ self.frames = { [1] = bbi, [2] = bbi, ... }  # Array of instance tables
       bbi = {
           frame      = Boss1TargetFrame,        # WoW frame reference
           healthBar  = Boss1TargetFrame.healthBar,
           manaBar    = Boss1TargetFrame.manabar,
           name       = { fontString = ... },
           -- ...
       }
```

**Sub-components loop over `self.frames`** in every method:

```lua
function BUFBossName:SetFont()
    for _, bbi in ipairs(BUFBoss.frames) do
        self:_SetFont(bbi.name.fontString)
    end
end
```

The `bbi` (boss/party instance) table holds references to that specific frame's sub-components.

### Positioning System

BUF uses a **relative positioning system** where every component can anchor to:

- `UIParent` (screen)
- The main frame
- Other sub-components (portrait, health bar, etc.)

Each top-level module defines:

```lua
BUFPlayer.relativeToFrames = {
    FRAME    = "PlayerFrame",
    PORTRAIT = "PlayerFrame.Portrait",
    NAME     = "PlayerFrame.name",
    HEALTH   = "PlayerFrame.healthBar",
    POWER    = "PlayerFrame.manabar",
}

BUFPlayer.customRelativeToOptions = {
    ["UIParent"]             = ns.L["UIParent"],
    ["PlayerFrame"]          = HUD_EDIT_MODE_PLAYER_FRAME_LABEL,
    ["PlayerFrame.Portrait"] = ns.L["PlayerPortrait"],
    -- ...
}
```

Sub-components call `BUFPlayer.FrameInit(self)` in their `RefreshConfig` guard to copy these tables (minus self-anchoring) so they can anchor to any part of the frame.

---

## How Skinning Works (vs oUF)

### oUF Approach

```lua
-- You create NEW frames from scratch
local frame = oUF:Spawn("player")
frame:SetSize(200, 50)
frame.Health = CreateFrame("StatusBar", nil, frame)
frame.Health:SetAllPoints()
-- You own the entire frame lifecycle
```

### BUF Approach

```lua
-- You MODIFY existing Blizzard frames
function BUFPlayer:OnEnable()
    self.frame = PlayerFrame  -- Grab reference to Blizzard's frame
    self.healthBar = PlayerFrame_GetHealthBar()
end

function BUFPlayer:RefreshConfig()
    -- Read settings from DB
    local width = self:DbGet("frame.width")
    local height = self:DbGet("frame.height")

    -- Apply to Blizzard's frame
    self.frame:SetSize(width, height)
    self.healthBar:SetStatusBarColor(...)
    self.frame.name:SetFont(...)
    -- Blizzard still owns the frame, you're just skinning it
end
```

**Key Points:**

1. **BUF never creates frames** — it modifies existing ones
2. **Blizzard still updates them** — you hook into their update code
3. **You apply visual changes** — size, color, font, position, texture
4. **State is in the DB** — `RefreshConfig()` reads DB and applies to frames

### Hooking Blizzard Updates

Since Blizzard owns the frames, they can overwrite your changes. To persist your settings:

```lua
-- Hook Blizzard's update function
self:SecureHook(PlayerFrame, "SetAttribute", function(frame, attr, value)
    if attr == "width" then
        -- Blizzard just changed width, reapply ours
        self:RefreshConfig()
    end
end)
```

BUF uses `AceHook-3.0` for safe, non-taint hooking.

### Combat Lockdown

Blizzard's unit frames are **secure** (protected during combat). You cannot:

- Move them during combat
- Change their size during combat
- Hook certain secure functions during combat

BUF handles this by:

1. Using `SecureHandlerAttributeTemplate` for combat-safe hooks
2. Deferring changes with `RegisterAttributeDriver`
3. Listening to `PLAYER_REGEN_ENABLED` (exiting combat) to apply deferred changes

See [unitFrames/player/player.lua](BeaconUnitFrames/unitFrames/player/player.lua) for examples.

---

## Making Your First Change

### Example: Add a New Option to Player Name

1. **Find the module:** `unitFrames/player/name/name.lua`

2. **Add DB default:**

```lua
BUFPlayerName.dbDefaults = {
    enabled = true,
    showServerName = false,  -- NEW
}
```

3. **Add option control:**

```lua
BUFPlayerName.optionsTable.args.showServerName = {
    type = "toggle",
    name = ns.L["Show Server Name"],
    get = "GetShowServerName",
    set = "SetShowServerName",
    order = 10,
}
```

4. **Add getter/setter:**

```lua
function BUFPlayerName:GetShowServerName(info)
    return self:DbGet("showServerName")
end

function BUFPlayerName:SetShowServerName(info, value)
    self:DbSet("showServerName", value)
    self:RefreshConfig()  -- Reapply config
end
```

5. **Update RefreshConfig to apply the setting:**

```lua
function BUFPlayerName:RefreshConfig()
    -- ... existing code ...

    if self:DbGet("showServerName") then
        self.fontString:SetText(UnitName("player") .. "-" .. GetRealmName())
    else
        self.fontString:SetText(UnitName("player"))
    end
end
```

6. **Add locale string:** In `locale/enUS.lua`:

```lua
L["Show Server Name"] = true
```

7. **Test in-game:**

```plain text
/reload
/buf  # Opens options panel
```

---

## Additional Resources

- [copilot-instructions.md](.github/copilot-instructions.md) — Project overview
- [core.instructions.md](.github/instructions/core.instructions.md) — Initialization flow
- [unitframes.instructions.md](.github/instructions/unitframes.instructions.md) — Frame architecture
- [options.instructions.md](.github/instructions/options.instructions.md) — Options system
- [mixins.instructions.md](.github/instructions/mixins.instructions.md) — Mixin reference
- [wow-ui-source/](../wow-ui-source/) — Blizzard's FrameXML source (read-only reference)

## Questions?

If anything is unclear or you get stuck, feel free to ask! The codebase is large but follows consistent patterns once you understand the feature module structure.
