# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [unreleased]

## Added
- `LiveViewNative.SwiftUI.normalize_os_version/1`
- `LiveViewNative.SwiftUI.normalize_app_version/1`

## Changed

## Fixed
- Updates to change-tracked properties no longer occur on the next RunLoop, fixing modal dismissal on macOS (#1450)

## [0.3.0] 2024-08-21

### Added
- `Stylesheet` type made public

### Changed
- Code-generated modifiers updated for Xcode 15.4

## Fixed

## [0.2]

### Changed

* removed modifiers and types
* migrated to `LiveViewNative.Stylesheet``
* renamed `LiveViewNativeSwiftUi` to `LiveViewNative.SwiftUI` module namespace
* Elixir `app` renamed to from `live_view_native_swift_ui` to `live_view_native_swiftui`

### Fixed

* Fix cached page rendering when nested in `<NavigationStac>`
* include original source in annotation
* Add `AttributeReference` to missing areas
* Stringify values from LiveForm
* Removed `Array<Self>` from parsers
