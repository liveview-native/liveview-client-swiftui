# LiveViewNative

The LiveViewNative Swift package lets you use Phoenix LiveView to build native iOS apps with SwiftUI.

## Installation

1. In Xcode, select *File → Add Packages...*
2. Enter the package URL `https://github.com/liveview-native/liveview-client-swiftui`
3. Select *Add Package*

## Usage
Create a `LiveView` to connect to a Phoenix server running on `http://localhost:4000`.

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
- Check out the [ElixirConf '22 chat app](https://github.com/liveview-native/elixirconf_chat) for an example of a complete app.
