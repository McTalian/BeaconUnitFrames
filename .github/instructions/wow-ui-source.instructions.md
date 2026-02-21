---
applyTo: "BeaconUnitFrames/**"
---

## What `wow-ui-source` Is

`../wow-ui-source` (relative to the addon root) is a **read-only reference copy** of Blizzard's UI source. It is never edited and Lua diagnostics are intentionally disabled on it. Consult it before assuming the shape, method names, or child frame structure of any Blizzard-provided frame.

## Directory Layout

```
wow-ui-source/
└── Interface/
    └── AddOns/
        ├── Blizzard_UnitFrame/        ← primary reference for this addon
        │   ├── Shared/                ← frame/template definitions shared across game versions
        │   └── Mainline/              ← Mainline-only frames and class resource bars
        ├── Blizzard_FrameXML/         ← core FrameXML templates and UI boilerplate
        ├── Blizzard_SharedXML/        ← utility mixins, animation templates, common widgets
        ├── Blizzard_SharedXMLBase/    ← lowest-level shared XML (frame templates, Mixin, etc.)
        ├── Blizzard_CompactRaidFrames/← compact party/raid frame reference
        └── Blizzard_RaidFrame/        ← raid frame reference
```

## Key Files for Unit Frame Work

| File                                                 | What to look for                                                  |
| ---------------------------------------------------- | ----------------------------------------------------------------- |
| `Blizzard_UnitFrame/Shared/UnitFrame.lua`            | Base `UnitFrameMixin`; `UnitFrame_Update`, `UnitFrame_SetUnit`    |
| `Blizzard_UnitFrame/Shared/UnitFrame.xml`            | Template inheritance tree for all unit frames                     |
| `Blizzard_UnitFrame/Shared/PlayerFrame.lua`          | `PlayerFrame` widget, `PlayerFrame_GetHealthBar()`, vehicle logic |
| `Blizzard_UnitFrame/Shared/PlayerFrameTemplates.xml` | `PlayerFrameTemplate` and child frame names                       |
| `Blizzard_UnitFrame/Shared/TargetFrame.lua`          | `TargetFrame` and ToT/ToFocus patterns                            |
| `Blizzard_UnitFrame/Shared/PartyFrame.lua`           | `PartyFrame`, `PartyFrame.MemberFrame1..5`                        |
| `Blizzard_UnitFrame/Mainline/`                       | `Boss1TargetFrame`–`Boss5TargetFrame`, class bars                 |
| `Blizzard_SharedXML/Mixin.lua`                       | `Mixin()`, `MixinAndOverrideParentMethods()` definitions          |
| `Blizzard_SharedXMLBase/`                            | `CreateFrame`, frame template anchors, `ScriptRegion` API         |

## How to Find a Frame's Child Structure

1. Search for the frame's global name (e.g. `"PlayerFrame"`) in `.xml` files to find the template that creates it.
2. Read the `<Frame>` or `<Button>` element's `inherits=""` attribute and trace the inheritance chain upward.
3. Child widget names follow the convention `ParentFrameName.ChildName` in Lua (e.g. `PlayerFrame.healthBar`) or `$parentChildName` in XML.
4. Confirm live global names with `_G["FrameName"]` notation — the source filename or template name does not always match the global.

## Searching the Source

- To find all usages of a Blizzard API function: search `.lua` files for the function name.
- To find where a frame template is defined: search `.xml` files for `name="TemplateName"`.
- To find what methods a frame mixin exposes: search for `function FrameNameMixin:` in the matching `.lua` file.
- The `Interface/ui-code-list.txt` file lists every source file in load order — useful when tracing initialization dependencies.

## Version Variants

Each `Blizzard_*` addon has multiple `.toc` files (e.g. `_Mainline.toc`, `_Wrath.toc`). BeaconUnitFrames targets Mainline (`@version-retail@`). When a file exists in both `Shared/` and `Mainline/`, the `Mainline/` version overrides or extends the shared one — check both.
