# ``LiveViewNative``
Use Phoenix LiveView to build native iOS apps with SwiftUI.

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Overview
The LiveViewNative Swift package lets you use Phoenix LiveView to build native iOS apps with SwiftUI.

## Installation

1. In Xcode, select *File → Add Packages...*
2. Enter the package URL `https://github.com/liveview-native/liveview-client-swiftui`
3. Select *Add Package*

## Usage
Create a `LiveView` and pass in a ``LiveViewHost`` or the `URL` to your Phoenix server.

```swift
import SwiftUI
import LiveViewNative

struct ContentView: View {
    var body: some View {
        LiveView(.localhost)
    }
}
```

Now when you start up your app, the LiveView will automatically connect and serve your native app.

## Elixir Library

This library is **experimental** in the current implementation. As we continue to develop the LiveView Native ecosystem this library will likely see rapid evolution and changes.

### Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `live_view_native_swift_ui` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:live_view_native_swift_ui, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/live_view_native_swift_ui>.

## Resources

- Browse the [documentation](https://liveview-native.github.io/liveview-client-swiftui/documentation/liveviewnative/) to read about the API.
- Follow the [tutorial](https://liveview-native.github.io/liveview-client-swiftui/tutorials/yourfirstapp) to get a step-by-step walkthrough of building an app with LiveView Native.
- Check out the [ElixirConf '22 chat app](https://github.com/liveview-native/elixirconf_chat) for an example of a complete app.

## Topics

### Essentials

- <doc:YourFirstApp>
- <doc:GettingStarted>
- ``LiveView``
- ``LiveSessionCoordinator``
- ``LiveSessionConfiguration``
- ``LiveViewCoordinator``

### Building a Live View Template

- <doc:AttributesVsModifiers>
- <doc:SupportedModifiers>

### Supported Elements

- <doc:ControlsAndIndicators>
- <doc:DrawingAndGraphics>
- <doc:Images>
- <doc:LayoutContainers>
- <doc:Shapes>
- <doc:TextInputAndOutput>
- <doc:Toolbars>

### Supported Modifiers
- <doc:AnimationsModifiers>
- <doc:ControlsAndIndicatorsModifiers>
- <doc:DocumentsModifiers>
- <doc:DrawingAndGraphicsModifiers>
- <doc:GesturesModifiers>
- <doc:ImagesModifiers>
- <doc:InputEventsModifiers>
- <doc:LayoutAdjustmentsModifiers>
- <doc:LayoutFundamentalsModifiers>
- <doc:ListsModifiers>
- <doc:MenusAndCommands>
- <doc:ModalPresentations>
- <doc:NavigationModifiers>
- <doc:ScrollViewsModifiers>
- <doc:SearchModifiers>
- <doc:TextInputAndOutputModifiers>
- <doc:ToolbarsModifiers>
- <doc:ViewConfigurationModifiers>
- <doc:ViewFundamentalsModifiers>
- <doc:ViewStylesModifiers>

### Custom DOM Elements and Attributes

- <doc:AddCustomElement>
- <doc:AddCustomModifier>
- ``CustomRegistry``

### Working with the DOM

- ``ElementNode``
- ``ObservedElement``
- ``Attribute``
- ``Event``
- ``LiveBinding``
- ``LiveContext``

### Form Controls
- <doc:FormControls>
- ``FormState``
- ``FormValue``
- ``FormModel``
