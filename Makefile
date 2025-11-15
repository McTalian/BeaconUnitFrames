.PHONY: lua_deps watch dev build

# Variables
ROCKSBIN := $(HOME)/.luarocks/bin

lua_deps:
	@luarocks install busted --local
	@luarocks install luacov --local
	@luarocks install luacov-html --local

# TODO: Add missling_locale_key_check and check_untracked_files checks as dependencies
watch:
	@wow-build-tools watch -t BeaconUnitFrames -r ./.release

dev:
	@wow-build-tools build -d -t BeaconUnitFrames -r ./.release --skipChangelog

build:
	@wow-build-tools build -d -t BeaconUnitFrames -r ./.release
