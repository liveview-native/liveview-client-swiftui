# SwiftUI Views

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fraw.githubusercontent.com%2Fliveview-native%liveview-client-swiftui%2Fmain%2Flivebooks%swiftui-views.livemd)

## Overview

LiveView Native aims to use minimal SwiftUI code and instead rely on the same patterns used in traditional Phoenix LiveView development as much as possible. We'll primarily use The LiveView Naive SwiftUI DSL (Domain Specific Language) to build the native template.

This lesson will teach you how to build SwiftUI templates using common SwiftUI views. We'll cover common use cases and provide practical examples of how to build native UIs. This lesson is like a recipe book you can refer to whenever you need an example of a particular SwiftUI view.

In addition, we'll cover the LiveView Native DSL and teach you how to convert SwiftUI examples into the LiveView Native DSL. Once you understand how to convert SwiftUI code into the LiveView Native DSL, you'll have the knowledge you need to learn from the plethora of [SwiftUI resources available](https://developer.apple.com/tutorials/swiftui/creating-and-combining-views).

<!-- livebook:{"break_markdown":true} -->

<!-- livebook:{"force_markdown":true} -->

```elixir
<Text>Hamlet</Text>
```

## Render Components

LiveView Native `0.3.0` introduced render components to encourage isolation of native and web templates. This pattern generally scales better than co-located templates within the same LiveView module.

Render components are namespaced under the main LiveView, and are responsible for defining the `render/1` callback function that returns the native template.

For example, in the cell below, the `ExampleLive` LiveView module has a corresponding `ExampleLive.SwiftUI` render component module for the native template. This `ExampleLive.SwiftUI` render component may define a `render/1` callback function, as seen below.

<!-- livebook:{"attrs":"eyJjb2RlIjoiIyBSZW5kZXIgQ29tcG9uZW50XG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlLlN3aWZ0VUkgZG9cbiAgdXNlIFNlcnZlck5hdGl2ZSwgWzpyZW5kZXJfY29tcG9uZW50LCBmb3JtYXQ6IDpzd2lmdHVpXVxuXG4gIGRlZiByZW5kZXIoYXNzaWducykgZG9cbiAgICB+TFZOXCJcIlwiXG4gICAgPFRleHQ+SGVsbG8sIGZyb20gTGl2ZVZpZXcgTmF0aXZlITwvVGV4dD5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuIyBMaXZlVmlld1xuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducykgZG9cbiAgICB+SFwiXCJcIlxuICAgIDxwPkhlbGxvIGZyb20gTGl2ZVZpZXchPC9wPlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,426],[515,49],[566,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
# Render Component
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Text>Hello, from LiveView Native!</Text>
    """
  end
end

# LiveView
defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <p>Hello from LiveView!</p>
    """
  end
end
```

Throughout this and further material, we'll re-define render components you can evaluate and see reflected in your Xcode iOS simulator.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxUZXh0PkhlbGxvLCBmcm9tIGEgTGl2ZVZpZXcgTmF0aXZlIFJlbmRlciBDb21wb25lbnQhPC9UZXh0PlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZCJ9","chunks":[[0,85],[87,233],[322,47],[371,51]],"kind":"Elixir.Server.SmartCells.RenderComponent","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <Text>Hello, from a LiveView Native Render Component!</Text>
    """
  end
end
```

In a Phoenix application, these two modules would traditionally be in separate files.

<!-- livebook:{"break_markdown":true} -->

### Embedding Templates

Instead of defining a `render/1` callback function, you may instead define a `.neex` (Native + Embedded Elixir) template.

By default, the module above would look for a template in the `swiftui/example_live*` path relative to the module's location. You can see the `LiveViewNative.Component` documentation for further explanation.

In Livebook, we'll use the `render/1` callback. However, we recommend using template files for local Phoenix + LiveView Native applications.

## SwiftUI Views

In SwiftUI, a "View" is like a building block for what you see on your app's screen. It can be something simple like text, or something more complex like a layout with multiple elements.

Here's an example `Text` view that represents a text element.

```swift
Text("Hamlet")
```

LiveView Native uses the following syntax to represent the view above.
