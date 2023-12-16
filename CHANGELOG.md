## v0.2

### Fixes
* Fix cached page rendering when nested in `<NavigationStac>`
* include original source in annotation
* Add `AttributeReference` to missing areas
* Stringify values from LiveForm
* Removed `Array<Self>` from parsers

### Breaking

* removed modifiers and types
* migrated to `LiveViewNative.Stylesheet``
* renamed `LiveViewNativeSwiftUi` to `LiveViewNative.SwiftUI` module namespace
* Elixir `app` renamed to from `live_view_native_swift_ui` to `live_view_native_swiftui`