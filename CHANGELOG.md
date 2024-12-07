# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [unreleased]

### Added

- LiveViewNative.SwiftUI.Client

### Changed

### Fixed

## [0.3.1] 2024-10-02

### Added
- `LiveViewNative.SwiftUI.normalize_os_version/1`
- `LiveViewNative.SwiftUI.normalize_app_version/1`
- Optional `LiveSessionConfiguration.headers`, sent when fetching the dead render (#1456)

### Changed
- Submitting a form will remove focus from all fields (#1451)

### Fixed
- Form elements will apply updates from a diff (#1451)
- Updates to change-tracked properties no longer occur on the next RunLoop, fixing modal dismissal on macOS (#1450)
- `+` characters are properly encoded as `%2B` in form events (#1449)
- Fixed retain cycle in `LiveViewCoordinator` (#1455)
- Made `StylesheetCache` thread-safe, fixing occasional crashes (#1461)
- Form elements outside of a `LiveForm` will show the value provided in the template (#1464)

## [0.3.0] 2024-08-21

### Added
- `Stylesheet` type made public

### Changed
- Code-generated modifiers updated for Xcode 15.4

### Fixed

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
