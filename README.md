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

You can install the client either by running the generator from Elixir or
you can manually add to an existing Xcode project.

### Both methods
1. Add `{:live_view_native_swiftui, "~> 0.3.0-rc.2}` to `mix.exs`
2. Add `LiveViewNative.SwiftUI` to the `plugins:` list of `config :live_view_native` in `config.exs`

<!-- tabs-open -->

### Generate Project
1. Run `mix help lvn.swiftui.gen` to see the options available for the generator
2. Run `mix lvn.gen --no-copy` to print the configuration settings to add to support SwiftUI in your application.
3. Run `mix lvn.swiftui.gen` to ensure you get the properly generated files. Please note this may overwrite an existing Xcode project.

### Add to existing Xcode project
1. Run `mix lvn.swiftui.gen --no-xcodegen`
2. In Xcode go to `Package Dependencies`
3. Select *File → Add Packages...*
4. Enter the package URL `https://github.com/liveview-native/liveview-client-swiftui`
5. Select *Add Package*

<!-- tabs-close -->

## Post-Installation

After installation will want to enable an exist LiveView for LiveView Native SwiftUI.

1. Run `mix lvn.gen.live swiftui <ContextModule>`
2. Add `use <NativeModule>, :live_view` to the LiveView module

#### Example

```
> mix lvn.gen.live swiftui Home
* creating lib/my_demo_web/live/home_live.swiftui.ex
* creating lib/my_demo_web/live/swiftui/home_live.swiftui.neex
```

```elixir
defmodule MyDemoWeb.HomeLive do
  use MyDemoWeb, :live_view
  use MyDemoNative, :live_view
end
```

Finally, if you generated your Xcode project from the `Mix` task you can open the `MyDemoWeb.xcodeproj` file within `native/swiftui`.

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
