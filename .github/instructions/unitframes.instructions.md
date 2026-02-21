---
applyTo: "BeaconUnitFrames/unitFrames/**"
---

## Composite Type Abstractions (`typeDefaults/`)

`options/typeDefaults/` defines composite handler types that bundle mixins + option injection + a `RefreshXxxConfig()` convenience method into a single `ApplyMixin` call. Use these instead of manually composing mixins when adding a new sub-component of a known type:

```lua
-- Font string sub-component (name, level, status bar text, etc.)
ns.BUFFontString:ApplyMixin(MyHandler)
-- Applies: Demoable, Sizable, Positionable, Justifiable, Fontable
-- Injects: ns.AddFontStringOptions into MyHandler.optionsTable.args
-- Provides: MyHandler:RefreshFontStringConfig() → calls SetPosition/SetSize/SetFont/SetFontShadow/UpdateJustification

-- Status bar sub-component (health bar container, power bar, etc.)
ns.BUFStatusBar:ApplyMixin(MyHandler)
-- Applies: Sizable, Positionable, Levelable
-- Injects: ns.AddStatusBarOptions
-- Provides: MyHandler:RefreshStatusBarConfig() → calls sub-handlers + SetPosition/SetSize/SetLevel
```

The handler must set `handler.optionsTable` before calling `ApplyMixin` for option injection to work. After the call, wire up the WoW frame object to `self.fontString` or `self.barOrContainer` respectively so the mixin methods have a target.

## Disabling Frames Requires a Reload

Disabling a top-level frame cannot be done live — Blizzard frames don't support being cleanly unconfigured at runtime. The convention across all frame modules is:

```lua
function BUFMyFrame:SetEnabled(info, value)
    self:DbSet("enabled", value)
    if value then
        self:RefreshConfig()
    else
        StaticPopup_Show("BUF_RELOAD_UI")  -- prompts user to /reload
    end
end
```

`BUF_RELOAD_UI` is registered once in `options/options.lua:125`. Do not add new popup dialogs for this — reuse it.

## Ace3 Module Lifecycle

Top-level frame modules use `OnEnable` (fired by Ace3) to cache live WoW frame references on `self` before `RefreshConfig` is ever called:

```lua
function BUFPlayer:OnEnable()
    self.frame     = PlayerFrame
    self.healthBar = PlayerFrame_GetHealthBar()
    -- ...
end
```

`RefreshConfig` then applies DB settings to those cached references. Sub-components receive references through the parent (e.g. `bbi.frame` in boss modules) rather than resolving via `_G` on each call.

## Positioning & `customRelativeToOptions`

Each top-level frame module declares a `relativeToFrames` alias map and a `customRelativeToOptions` table that drives the "Relative To" dropdown for all its sub-components:

```lua
BUFPlayer.relativeToFrames = {
    FRAME  = ns.Positionable.relativeToFrames.PLAYER_FRAME,   -- "PlayerFrame"
    HEALTH = ns.Positionable.relativeToFrames.PLAYER_HEALTH_BAR,
}
BUFPlayer.customRelativeToOptions = { ["PlayerFrame"] = HUD_EDIT_MODE_PLAYER_FRAME_LABEL, ... }
BUFPlayer.customRelativeToSorting = { "UIParent", "PlayerFrame", ... }  -- display order
```

Always use `ns.Positionable.relativeToFrames` constants as keys — not raw strings — so frame path changes propagate automatically.

Sub-components call the parent's `FrameInit` inside their `RefreshConfig` guard:

```lua
function CastBar:RefreshConfig()
    if not self.initialized then
        BUFBoss.FrameInit(self)  -- copies parent's customRelativeToOptions, strips self-anchoring
        -- one-time frame setup
    end
    -- ...
end
```

`FrameInit` (defined per parent module via `options/options.lua`) copies the parent's `customRelativeToOptions`/`customRelativeToSorting` onto `self`, removes the sub-component's own `frameKey` to prevent self-anchoring, and sets `self.initialized = true`.

At runtime, `Positionable:GetRelativeToOptions()` returns `self.customRelativeToOptions` if present, otherwise falls back to `Positionable.anchorRelativeToOptions`. `ns.GetRelativeFrame(strKey)` resolves a frame name string to the live WoW frame object at call time.

## Multi-Instance Frames (Boss & Party)

Boss and Party differ from single-unit frames in one fundamental way: they manage **an array of identical frame instances** rather than a single frame.

**`OnEnable`** builds `self.frames` via a per-type instance factory:

```lua
function BUFBoss:OnEnable()
    self.frames = {}
    for i = 1, MAX_BOSS_FRAMES do
        table.insert(self.frames, BUFBossInstance:New(i))
    end
end
```

`BUFBossInstance:New(index)` resolves the indexed WoW frame (`_G["Boss" .. index .. "TargetFrame"]`) and caches its sub-frame references (`frame`, `healthBar`, `manaBar`, etc.) into an instance table (`bbi`). Party uses `PartyFrame["MemberFrame" .. index]` with the same shape.

**Sub-components** loop over `self.frames` in every method — `RefreshConfig`, `SetPosition`, `SetSize`, `SetFont`, etc.:

```lua
function BUFBossName:SetPosition()
    for _, bbi in ipairs(BUFBoss.frames) do
        self:_SetPosition(bbi.name.fontString)
    end
end
```

The `FrameInit` guard also iterates `self.frames` to cache per-instance sub-frame refs onto `bbi`:

```lua
if not self.initialized then
    BUFBoss.FrameInit(self)
    for _, bbi in ipairs(BUFBoss.frames) do
        bbi.name = {}
        bbi.name.fontString = bbi.contentMain.Name
        bbi.name.fontString.bufOverrideParentFrame = bbi.frame  -- passes instance context through positioning
    end
end
```

**Positioning** uses a frame-type-specific positionable (`BUFBossPositionable`, `BUFPartyPositionable`) mixed in instead of the default `ns.Positionable`. These override `GetRelativeFrame` and `GetPositionAnchorInfo` to accept a `parentFrame` instance argument, resolving sub-frame paths relative to that instance rather than via `_G`. The `bufOverrideParentFrame` field set on WoW frame objects is how the parent instance flows through to `_SetPosition`.

## Combat Lockdown

WoW blocks direct frame manipulation during combat. For frames that must react to Blizzard-driven state changes (vehicle enter/exit, art updates), use `SecureHandlerAttributeTemplate` + `RegisterAttributeDriver`:

```lua
-- Inside the if not self.initialized block in RefreshConfig:
local handler = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
ns.Mixin(handler, ns.BUFSecureHandler)
RegisterAttributeDriver(handler, "vehicleunit", "[@vehicle,exists] 1; 0")
```

Hook points that may fire in combat use `SecureHandlerWrapScript`. Non-secure work that can't be deferred uses an `InCombatLockdown()` check with a one-shot `PLAYER_REGEN_ENABLED` listener to retry after combat ends. See `unitFrames/player/player.lua:RefreshConfig` for the full pattern.
