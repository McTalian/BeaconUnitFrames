---
applyTo: "BeaconUnitFrames/options/**"
---

## Mixin Composition
Reusable option behaviors live in `options/mixins/`. Each mixin is a table mixed into a handler with `ns.Mixin`, and always pairs with a standalone `AddXxxOptions(optionsTable, orderMap)` function that injects the Ace3 option controls. See `options/mixins/sizable.lua` for the canonical pattern:
```lua
-- 1. Add controls to an options table:
ns.AddSizableOptions(myHandler.optionsTable, myOrderMap)

-- 2. Mix behavior into the handler:
ns.Mixin(myHandler, ns.MixinBase)
ns.Mixin(myHandler, ns.Sizable, ns.Positionable, ns.Colorable)
```
All mixins inherit `ProfileDbBackedHandler` via `ns.MixinBase`, so `DbGet`/`DbSet`/`DbClear` are available on any mixed-in handler.

Available mixins: `Sizable`, `Positionable`, `Fontable`, `Colorable`, `ClassColorable`, `PowerColorable`, `ReactionColorable`, `StatusBarTexturable`, `BackgroundTexturable`, `Maskable`, `AtlasSizable`, `Justifiable`, `Demoable`.

## Options Table Schema
Options follow Ace3 config schema. Key conventions:
- `set`/`get` are **strings** referencing handler method names, not function references
- Ordering uses named constants from `ns.defaultOrderMap` (defined in `options/options.lua`) rather than raw numbers — use fractional values to insert between existing entries without renumbering
- Default config blocks for reusable component types live in `options/typeDefaults/` (e.g. `statusBar.lua`, `fontString.lua`, `texture.lua`) — compose from these before writing a custom block

```lua
myHandler.optionsTable = {
    type    = "group",
    name    = ns.L["My Component"],
    handler = myHandler,
    args    = {},
}
ns.AddSizableOptions(myHandler.optionsTable)      -- inject width/height controls
ns.AddPositionableOptions(myHandler.optionsTable) -- inject anchor/offset controls
```
