# LiveViewNative

> #### Client Spec {: .info}
>
> ```elixir
> format: :swiftui
> module_suffix: "SwiftUI"
> template_sigil: ~LVN
> component: LiveViewNative.SwiftUI.Component 
> targets: ~w{ios ipados macos maccatalyst watchos tvos visionos unknown}
> ```

The LiveViewNative Swift package lets you use Phoenix LiveView to build native iOS apps with SwiftUI.

## Installation

<!-- tabs-open -->

### Elixir
1. Add `{:live_view_native_swiftui, "~> 0.3.0-rc.2}` to `mix.exs`
2. Add `LiveViewNative.SwiftUI` to the `plugins:` list of `config :live_view_native` in `config.exs`
3. Run `mix help lvn.swiftui.gen` to see the options available for the generator
4. You may want to re-run `mix lvn.setup` to ensure you get the properly generated files

### Xcode
1. In Xcode, select *File → Add Packages...*
2. Enter the package URL `https://github.com/liveview-native/liveview-client-swiftui`
3. Select *Add Package*

<!-- tabs-close -->

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

### Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `live_view_native_swiftui` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:live_view_native_swiftui, "~> 0.3.0"}
  ]
end
```

Then add the `SwiftUI` plugin to your list of LiveView Native plugins:

```elixir
config :live_view_native, plugins: [
  LiveViewNative.SwiftUI
]
```

## Usage

This plugin provides the SwiftUI rendering behavior of a Phoenix LiveView. Start by adding this plugin to a LiveView. We do this with `LiveViewNative.LiveView`:

```elixir
defmodule MyAppWeb.HomeLive do
  use MyAppWeb :live_view
  use LiveViewNative.LiveView,
    formats: [:swiftui],
    layouts: [
      swiftui: {MyAppWeb.Layouts.SwiftUI, :app}
    ]

end
```

then just like all format LiveView Native rendering components you will create a new module namespaced under the calling module with the `module_suffix` appended:

```elixir
defmodule MyAppWeb.HomeLive.SwiftUI do
  use LiveViewNative.Component,
    format: :swiftui

  def render(assigns, _interface) do
    ~LVN"""
    <Text>Hello, SwiftUI!</Text>
    """
  end
end
```

Further details on additional options and an explanation of template rendering vs using `render/2` are in the LiveView Native docs.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/live_view_native_swiftui>.

## Resources

- Browse the [documentation](https://liveview-native.github.io/liveview-client-swiftui/documentation/liveviewnative/) to read about the API.
- Check out the [ElixirConf '22 chat app](https://github.com/liveview-native/elixirconf_chat) for an example of a complete app.
