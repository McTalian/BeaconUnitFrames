---
applyTo: "BeaconUnitFrames/options/mixins/**"
---

## Two-Part Structure

Every mixin file exports two things:

1. **`ns.AddXxxOptions(optionsTable, _orderMap)`** — a standalone function that injects Ace3 option controls into an existing options table.
2. **`ns.Xxxable`** — a mixin table mixed with `ns.MixinBase` that provides the get/set/behavior methods.

These are always kept in the same file and designed to be used together, but they are separate concerns: the options function is called at options-table construction time; the mixin is applied to the handler object.

## Options Function Pattern

```lua
--- @param optionsTable table        -- the .args table of an Ace3 group
--- @param _orderMap BUFOptionsOrder? -- optional, falls back to ns.defaultOrderMap
function ns.AddXxxOptions(optionsTable, _orderMap)
    local orderMap = _orderMap or ns.defaultOrderMap

    optionsTable.xxxHeader = optionsTable.xxxHeader or {
        type  = "header",
        name  = ns.L["Xxx Section Label"],
        order = orderMap.XXX_HEADER,
    }

    optionsTable.someControl = {
        type  = "range",  -- or "toggle", "color", "select", etc.
        name  = ns.L["Control Label"],
        set   = "SetSomeValue",   -- string method name on the handler
        get   = "GetSomeValue",   -- string method name on the handler
        order = orderMap.SOME_VALUE,
    }
end
```

- Always use **string** method names for `set`/`get`/`disabled` — not function references. Ace3 calls `handler[methodName](handler, info, ...)`.
- Use `orderMap` constants from `ns.defaultOrderMap` for all `order` values. Insert between existing entries with fractional values rather than renumbering.
- Headers use `or` assignment so callers that already added a header with the same key don't get a duplicate.
- Optional parameters that change which controls are injected follow the `alwaysEnabled boolean?` pattern from `colorable.lua` — add them as trailing parameters after `_orderMap`.

## Mixin Table Pattern

```lua
---@class XxxableHandler: MixinBase
---@field RefreshXxx fun(self: XxxableHandler)  -- must be implemented by the handler

---@class Xxxable: XxxableHandler
local Xxxable = {}

ns.Mixin(Xxxable, ns.MixinBase)

function Xxxable:SetSomeValue(info, value)
    self:DbSet("someKey", value)
    self:RefreshXxx()   -- delegate to the handler's runtime update method
end

function Xxxable:GetSomeValue(info)
    return self:DbGet("someKey")
end

ns.Xxxable = Xxxable
```

Key rules:

- Always call `ns.Mixin(Xxxable, ns.MixinBase)` to inherit `DbGet`/`DbSet`/`DbClear`.
- Set/get methods persist to DB then call a **`RefreshXxx`** method — they never touch the WoW frame directly. The consuming handler is responsible for implementing `RefreshXxx`.
- Use `---@class XxxableHandler` to document the interface that the consuming handler must satisfy, and `---@class Xxxable: XxxableHandler` as the mixin's own annotation. This lets LuaLS type-check both sides.
- Publish as `ns.Xxxable` at the bottom of the file.

## `disabled` Callbacks

If a control should be conditionally greyed out, add a `disabled` key using a string method name:

```lua
optionsTable.someControl = {
    ...
    disabled = "IsSomeValueDisabled",
}

function Xxxable:IsSomeValueDisabled(info)
    return self:DbGet("someToggle") == false
end
```

## Applying a Mixin to a Handler

```lua
ns.Mixin(MyHandler, ns.MixinBase)
ns.Mixin(MyHandler, ns.Xxxable, ns.Yyable)
ns.AddXxxOptions(MyHandler.optionsTable)
ns.AddYyOptions(MyHandler.optionsTable)

function MyHandler:RefreshXxx()
    -- apply DbGet("someKey") to self.myWoWFrame
end
```

Multiple mixins compose without conflict as long as their DB keys and method names are distinct. The `typeDefaults/` composites (`ns.BUFFontString`, `ns.BUFStatusBar`, etc.) bundle common mixin combinations — prefer those over manually composing individual mixins when a matching composite exists.
