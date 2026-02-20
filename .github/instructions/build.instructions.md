---
applyTo: "Makefile,**/*.toc,**/.pkgmeta,**/*.rockspec,**/pyproject.toml,.release/**"
---

## Build Tool
`wow-build-tools` is a compiled Go CLI (custom tool, on PATH). The `Makefile` wraps it with pre-flight checks. **Builds fail if any untracked git files exist** (`check_untracked_files` runs automatically).

```sh
make watch          # watch mode — rebuilds on file change (use during active dev)
make dev            # one-shot dev build, skips changelog
make build          # production build with changelog
make toc_check      # validate all files declared in TOC/index.xml
make toc_update     # auto-update interface versions in TOC
make i18n_check     # find missing locale keys
make i18n_fmt       # reformat/organize translation files
make lua_deps       # install busted/luacov for Lua testing
```

For the typical dev loop: `wow-build-tools build link` creates symlinks from the WoW AddOns directory into `.release/`, then `make watch` keeps the build hot — a `/reload` in-game picks up changes immediately.

## Output Directory (`.release/`)
`.release/` is **fully generated output** — every build wipes and recreates it. **Never edit files inside `.release/` directly.** All changes must be made to source files under `BeaconUnitFrames/`.

The symlink created by `wow-build-tools build link` points WoW's AddOns directory at `.release/BeaconUnitFrames/`, so the game always runs the build output. Edits made directly to `.release/` will be silently overwritten on the next build.

## Build-time Tokens
`wow-build-tools` performs keyword substitution in `.toc`, `.lua`, `.xml`, `.md`, and `.txt` files. **Never modify or remove any `@token@` string.**

*Value substitution* (replaced inline):
`@project-version@`, `@project-hash@`, `@project-abbreviated-hash@`, `@project-author@`, `@project-date-iso@`, `@project-date-integer@`, `@project-timestamp@`, `@project-revision@`, `@file-revision@`, `@file-hash@`, `@file-abbreviated-hash@`, `@file-author@`, `@file-date-iso@`, `@file-date-integer@`, `@file-timestamp@`, `@build-date@`, `@build-date-iso@`, `@build-date-integer@`, `@build-timestamp@`, `@package-name@`, `@localization@`

*Conditional blocks* — code between the open/close tags is included only in matching build types:
- Lua syntax: `--@token@` … `--@end-token@`
- XML syntax: `<!--@token@-->` … `<!--@end-token@-->`

Tokens: `@alpha@`, `@beta@`, `@debug@`, `@do-not-package@`, `@no-lib-strip@`, `@retail@`, `@version-retail@`, `@version-classic@`, `@version-bcc@`, `@version-wrath@`, `@version-cata@`, `@version-mop@`, `@version-wod@`, `@version-legion@`, `@version-bfa@`, `@version-sl@`, `@version-df@`, `@version-tww@`

Example from `core.lua` — exported only in alpha builds:
```lua
--@alpha@
_G["BeaconUnitFrames"] = ns
--@end-alpha@
```
