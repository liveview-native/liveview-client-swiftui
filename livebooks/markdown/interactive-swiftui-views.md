# Interactive SwiftUI Views

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fraw.githubusercontent.com%2Fliveview-native%liveview-client-swiftui%2Fmain%2Flivebooks%interactive-swiftui-views.livemd)

## Overview

In this guide, you'll learn how to build interactive LiveView Native applications using event bindings.

This guide assumes some existing familiarity with [Phoenix Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) and how to set/access state stored in the LiveView's socket assigns. To get the most out of this material, you should already understand the `assign/3`/`assign/2` function, and how event bindings such as `phx-click` interact with the `handle_event/3` callback function.

We'll use the following LiveView and define new render component examples throughout the guide.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxUZXh0PkhlbGxvLCBmcm9tIExpdmVWaWV3IE5hdGl2ZSE8L1RleHQ+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,347],[436,49],[487,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Text>Hello, from LiveView Native!</Text>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""
end
```

## Event Bindings

We can bind any available `phx-*` [Phoenix Binding](https://hexdocs.pm/phoenix_live_view/bindings.html) to a SwiftUI Element. However certain events are not available on native.

LiveView Native currently supports the following events on all SwiftUI views:

* `phx-window-focus`: Fired when the application window gains focus, indicating user interaction with the Native app.
* `phx-window-blur`: Fired when the application window loses focus, indicating the user's switch to other apps or screens.
* `phx-focus`: Fired when a specific native UI element gains focus, often used for input fields.
* `phx-blur`: Fired when a specific native UI element loses focus, commonly used with input fields.
* `phx-click`: Fired when a user taps on a native UI element, enabling a response to tap events.

> The above events work on all SwiftUI views. Some events are only available on specific views. For example, `phx-change` is available on controls and `phx-throttle/phx-debounce` is available on views with events.

There is also a [Pull Request](https://github.com/liveview-native/liveview-client-swiftui/issues/1095) to add Key Events which may have been merged since this guide was published.

## Basic Click Example

The `phx-click` event triggers a corresponding [handle_event/3](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3) callback function whenever a SwiftUI view is pressed.

In the example below, the client sends a `"ping"` event to the server, and trigger's the LiveView's `"ping"` event handler.

Evaluate the example below, then click the `"Click me!"` button. Notice `"Pong"` printed in the server logs below.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxCdXR0b24gcGh4LWNsaWNrPVwicGluZ1wiPlByZXNzIG1lIG9uIG5hdGl2ZSE8L0J1dHRvbj5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJwaW5nXCIsIF9wYXJhbXMsIHNvY2tldCkgZG9cbiAgICBJTy5wdXRzKFwiUG9uZ1wiKVxuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,469],[558,49],[609,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Button phx-click="ping">Press me on native!</Button>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("ping", _params, socket) do
    IO.puts("Pong")
    {:noreply, socket}
  end
end
```

### Click Events Updating State

Event handlers in LiveView can update the LiveView's state in the socket.

Evaluate the cell below to see an example of incrementing a count.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxCdXR0b24gcGh4LWNsaWNrPVwiaW5jcmVtZW50XCI+Q291bnQ6IDwlPSBAY291bnQgJT48L0J1dHRvbj5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBtb3VudChfcGFyYW1zLCBfc2Vzc2lvbiwgc29ja2V0KSBkb1xuICAgIHs6b2ssIGFzc2lnbihzb2NrZXQsIDpjb3VudCwgMCl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcImluY3JlbWVudFwiLCBfcGFyYW1zLCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCA6Y291bnQsIHNvY2tldC5hc3NpZ25zLmNvdW50ICsgMSl9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,601],[690,49],[741,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Button phx-click="increment">Count: <%= @count %></Button>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 0)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("increment", _params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count + 1)}
  end
end
```

### Your Turn: Decrement Counter

You're going to take the example above, and create a counter that can **both increment and decrement**.

There should be two buttons, each with a `phx-click` binding. One button should bind the `"decrement"` event, and the other button should bind the `"increment"` event. Each event should have a corresponding handler defined using the `handle_event/3` callback function.

### Example Solution

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <!-- Displays the current count -->
    <Text><%= @count %></Text>

    <!-- Enter your solution below -->
    <Button phx-click="increment">Increment</Button>
    <Button phx-click="decrement">Decrement</Button>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 0)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("increment", _params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count + 1)}
  end

  def handle_event("decrement", _params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count - 1)}
  end
end
```



<!-- livebook:{"break_markdown":true} -->

### Enter Your Solution Below

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwhLS0gRGlzcGxheXMgdGhlIGN1cnJlbnQgY291bnQgLS0+XG4gICAgPFRleHQ+PCU9IEBjb3VudCAlPjwvVGV4dD5cblxuICAgIDwhLS0gRW50ZXIgeW91ciBzb2x1dGlvbiBiZWxvdyAtLT5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBtb3VudChfcGFyYW1zLCBfc2Vzc2lvbiwgc29ja2V0KSBkb1xuICAgIHs6b2ssIGFzc2lnbihzb2NrZXQsIDpjb3VudCwgMCl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,511],[600,49],[651,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <!-- Displays the current count -->
    <Text><%= @count %></Text>

    <!-- Enter your solution below -->
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 0)}
  end

  @impl true
  def render(assigns), do: ~H""
end
```

## Selectable Lists

`List` views support selecting items within the list based on their id. To select an item, provide the `selection` attribute with the item's id.

Pressing a child item in the `List` on a native device triggers the `phx-change` event. In the example below we've bound the `phx-change` event to send the `"selection-changed"` event. This event is then handled by the `handle_event/3` callback function and used to change the selected item.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXN0IHNlbGVjdGlvbj17QHNlbGVjdGlvbn0gcGh4LWNoYW5nZT1cInNlbGVjdGlvbi1jaGFuZ2VkXCI+XG4gICAgICA8VGV4dCA6Zm9yPXtpIDwtIDEuLjEwfSBpZD17XCIje2l9XCJ9Pkl0ZW0gPCU9IGkgJT48L1RleHQ+XG4gICAgPC9MaXN0PlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuXG4gIEBpbXBsIHRydWVcbiAgZGVmIG1vdW50KF9wYXJhbXMsIF9zZXNzaW9uLCBzb2NrZXQpIGRvXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgc2VsZWN0aW9uOiBcIk5vbmVcIil9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInNlbGVjdGlvbi1jaGFuZ2VkXCIsICV7XCJzZWxlY3Rpb25cIiA9PiBzZWxlY3Rpb259LCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCBzZWxlY3Rpb246IHNlbGVjdGlvbil9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,701],[790,49],[841,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <List selection={@selection} phx-change="selection-changed">
      <Text :for={i <- 1..10} id={"#{i}"}>Item <%= i %></Text>
    </List>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, selection: "None")}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("selection-changed", %{"selection" => selection}, socket) do
    {:noreply, assign(socket, selection: selection)}
  end
end
```

## Expandable Lists

`List` views support hierarchical content using the [DisclosureGroup](https://developer.apple.com/documentation/swiftui/disclosuregroup) view. Nest `DisclosureGroup` views within a list to create multiple levels of content as seen in the example below.

To control a `DisclosureGroup` view, use the `isExpanded` boolean attribute as seen in the example below.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXN0PlxuICAgICAgPERpc2Nsb3N1cmVHcm91cCBwaHgtY2hhbmdlPVwidG9nZ2xlXCIgaXNFeHBhbmRlZD17QGlzX2V4cGFuZGVkfT5cbiAgICAgICAgPFRleHQgdGVtcGxhdGU9XCJsYWJlbFwiPkxldmVsIDE8L1RleHQ+XG4gICAgICAgIDxUZXh0Pkl0ZW0gMTwvVGV4dD5cbiAgICAgICAgPFRleHQ+SXRlbSAyPC9UZXh0PlxuICAgICAgICA8VGV4dD5JdGVtIDM8L1RleHQ+XG4gICAgICA8L0Rpc2Nsb3N1cmVHcm91cD5cbiAgICA8L0xpc3Q+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICB7Om9rLCBhc3NpZ24oc29ja2V0LCA6aXNfZXhwYW5kZWQsIGZhbHNlKX1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgaGFuZGxlX2V2ZW50KFwidG9nZ2xlXCIsICV7XCJpc0V4cGFuZGVkXCIgPT4gaXNfZXhwYW5kZWR9LCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCBpc19leHBhbmRlZDogaXNfZXhwYW5kZWQpfVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,807],[896,49],[947,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <List>
      <DisclosureGroup phx-change="toggle" isExpanded={@is_expanded}>
        <Text template="label">Level 1</Text>
        <Text>Item 1</Text>
        <Text>Item 2</Text>
        <Text>Item 3</Text>
      </DisclosureGroup>
    </List>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :is_expanded, false)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("toggle", %{"isExpanded" => is_expanded}, socket) do
    {:noreply, assign(socket, is_expanded: is_expanded)}
  end
end
```

### Multiple Expandable Lists

The next example shows one pattern for displaying multiple expandable lists without needing to write multiple event handlers.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXN0PlxuICAgICAgPERpc2Nsb3N1cmVHcm91cCBwaHgtY2hhbmdlPVwidG9nZ2xlLTFcIiBpc0V4cGFuZGVkPXtAZXhwYW5kZWRfZ3JvdXBzWzFdfT5cbiAgICAgICAgPFRleHQgdGVtcGxhdGU9XCJsYWJlbFwiPkxldmVsIDE8L1RleHQ+XG4gICAgICAgIDxUZXh0Pkl0ZW0gMTwvVGV4dD5cbiAgICAgICAgPERpc2Nsb3N1cmVHcm91cCBwaHgtY2hhbmdlPVwidG9nZ2xlLTJcIiBpc0V4cGFuZGVkPXtAZXhwYW5kZWRfZ3JvdXBzWzJdfT5cbiAgICAgICAgICA8VGV4dCB0ZW1wbGF0ZT1cImxhYmVsXCI+TGV2ZWwgMjwvVGV4dD5cbiAgICAgICAgICA8VGV4dD5JdGVtIDI8L1RleHQ+XG4gICAgICAgIDwvRGlzY2xvc3VyZUdyb3VwPlxuICAgICAgPC9EaXNjbG9zdXJlR3JvdXA+XG4gICAgPC9MaXN0PlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuXG4gIEBpbXBsIHRydWVcbiAgZGVmIG1vdW50KF9wYXJhbXMsIF9zZXNzaW9uLCBzb2NrZXQpIGRvXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgOmV4cGFuZGVkX2dyb3VwcywgJXsxID0+IGZhbHNlLCAyID0+IGZhbHNlfSl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInRvZ2dsZS1cIiA8PiBsZXZlbCwgJXtcImlzRXhwYW5kZWRcIiA9PiBpc19leHBhbmRlZH0sIHNvY2tldCkgZG9cbiAgICBsZXZlbCA9IFN0cmluZy50b19pbnRlZ2VyKGxldmVsKVxuICAgIHs6bm9yZXBseSxcbiAgICAgYXNzaWduKFxuICAgICAgIHNvY2tldCxcbiAgICAgICA6ZXhwYW5kZWRfZ3JvdXBzLFxuICAgICAgIE1hcC5yZXBsYWNlIShzb2NrZXQuYXNzaWducy5leHBhbmRlZF9ncm91cHMsIGxldmVsLCBpc19leHBhbmRlZClcbiAgICAgKX1cbiAgZW5kXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,1108],[1197,49],[1248,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <List>
      <DisclosureGroup phx-change="toggle-1" isExpanded={@expanded_groups[1]}>
        <Text template="label">Level 1</Text>
        <Text>Item 1</Text>
        <DisclosureGroup phx-change="toggle-2" isExpanded={@expanded_groups[2]}>
          <Text template="label">Level 2</Text>
          <Text>Item 2</Text>
        </DisclosureGroup>
      </DisclosureGroup>
    </List>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :expanded_groups, %{1 => false, 2 => false})}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("toggle-" <> level, %{"isExpanded" => is_expanded}, socket) do
    level = String.to_integer(level)

    {:noreply,
     assign(
       socket,
       :expanded_groups,
       Map.replace!(socket.assigns.expanded_groups, level, is_expanded)
     )}
  end
end
```

## Forms

In Phoenix, form elements must be inside of a form. Phoenix only captures events if the element is wrapped in a form. However in SwiftUI there is no similar concept of forms. To bridge the gap, we built the [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form) library. This library provides several views to enable writing views in a single form.

Phoenix Applications setup with LiveView native include a `core_components.ex` file. This file contains several components for building forms. Generally, We recommend using core components rather than the views. We're going to cover the views directly so you understand how to build forms from scratch and how we built the core components. However, in the [Forms and Validations](https://hexdocs.pm/live_view_native/forms-and-validation.html) reading we'll cover using core components.

<!-- livebook:{"break_markdown":true} -->

### LiveForm

The `LiveForm` view must wrap views to capture events from the `phx-change` or `phx-submit` event. The `phx-change` event sends a message to the LiveView anytime the control or indicator changes its value. The `phx-submit` event sends a message to the LiveView when a user clicks the `LiveSubmitButton`. The params of the message are based on the name of the [Binding](https://developer.apple.com/documentation/swiftui/binding) argument of the view's initializer in SwiftUI.

Here's some example boilerplate for a `LiveForm`. The `id` attribute is required.

```html
<LiveForm id="some-id" phx-change="change" phx-submit="submit">
  <!-- inputs go here -->
  <LiveSubmitButton>Button Text</LiveSubmitButton>
</LiveForm>
```

<!-- livebook:{"break_markdown":true} -->

### Basic Example using TextField

The following example shows you how to connect a SwiftUI [TextField](https://developer.apple.com/documentation/swiftui/textfield) with a `phx-change` event and `phx-submit` binding to a corresponding event handler.

Evaluate the example below. Type into the text field and press submit on your iOS simulator. Notice the inspected `params` appear in the server logs in the console below as a map of `%{"my-input" => value}` based on the `name` attribute on the `TextField` view.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXZlRm9ybSBpZD1cIm15LWZvcm1cIiBwaHgtY2hhbmdlPVwiY2hhbmdlXCIgcGh4LXN1Ym1pdD1cInN1Ym1pdFwiPlxuICAgICAgPFRleHRGaWVsZCBuYW1lPVwibXktaW5wdXRcIj5FbnRlciB0ZXh0IGhlcmU8L1RleHRGaWVsZD5cbiAgICAgIDxMaXZlU3VibWl0QnV0dG9uPlN1Ym1pdDwvTGl2ZVN1Ym1pdEJ1dHRvbj5cbiAgICA8L0xpdmVGb3JtPlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuICByZXF1aXJlIExvZ2dlclxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcImNoYW5nZVwiLCBwYXJhbXMsIHNvY2tldCkgZG9cbiAgICBMb2dnZXIuaW5mbyhcIkNoYW5nZSBwYXJhbXM6ICN7aW5zcGVjdChwYXJhbXMpfVwiKVxuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJzdWJtaXRcIiwgcGFyYW1zLCBzb2NrZXQpIGRvXG4gICAgTG9nZ2VyLmluZm8oXCJTdWJtaXR0ZWQgcGFyYW1zOiAje2luc3BlY3QocGFyYW1zKX1cIilcbiAgICB7Om5vcmVwbHksIHNvY2tldH1cbiAgZW5kXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,804],[893,49],[944,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <LiveForm id="my-form" phx-change="change" phx-submit="submit">
      <TextField name="my-input">Enter text here</TextField>
      <LiveSubmitButton>Submit</LiveSubmitButton>
    </LiveForm>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view
  require Logger

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("change", params, socket) do
    Logger.info("Change params: #{inspect(params)}")
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", params, socket) do
    Logger.info("Submitted params: #{inspect(params)}")
    {:noreply, socket}
  end
end
```

### Event Handlers

The `phx-change` and `phx-submit` event handlers should generally be bound to the LiveForm. However, you can also bind the event handlers directly to the input view if you want to separately handle a single view's change events.

<!-- livebook:{"force_markdown":true} -->

```elixir
<LiveForm id="my-form">
  <TextField name="my-input" phx-change="change">Enter text here</TextField>
  <LiveSubmitButton>Submit</LiveSubmitButton>
</LiveForm>
```

## Controls and Indicators

SwiftUI organizes interactive views in the [Controls and Indicators](https://developer.apple.com/documentation/swiftui/controls-and-indicators) section. You may refer to this documentation when looking for views that belong within a form.

We'll demonstrate how to work with a few common control and indicator views.

<!-- livebook:{"break_markdown":true} -->

### Slider

This code example renders a SwiftUI [Slider](https://developer.apple.com/documentation/swiftui/slider). It triggers the change event when the slider is moved and sends a `"slide"` message. The `"slide"` event handler then logs the value to the console.

The [Slider](https://developer.apple.com/documentation/swiftui/slider) view uses **named content areas** `minumumValueLabel` and `maximumValueLabel`. The example below demonstrates how to represent these areas using the `template` attribute.

This example also demonstrates how to use the params sent by the slider to store a value in the socket and use it elsewhere in the template.

Evaluate the example and enter some text in your iOS simulator.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXZlRm9ybSBpZD1cIm15LWZvcm1cIiBwaHgtY2hhbmdlPVwic2xpZGVcIj5cbiAgICAgIDxTbGlkZXJcbiAgICAgICAgbmFtZT1cIm15LXNsaWRlclwiXG4gICAgICAgIGxvd2VyQm91bmQ9ezB9XG4gICAgICAgIHVwcGVyQm91bmQ9ezEwMH1cbiAgICAgICAgc3RlcD17MX1cbiAgICAgID5cbiAgICAgICAgPFRleHQgdGVtcGxhdGU9ezptaW5pbXVtVmFsdWVMYWJlbH0+MCU8L1RleHQ+XG4gICAgICAgIDxUZXh0IHRlbXBsYXRlPXs6bWF4aW11bVZhbHVlTGFiZWx9PjEwMCU8L1RleHQ+XG4gICAgICA8L1NsaWRlcj5cbiAgICA8L0xpdmVGb3JtPlxuICAgIDxUZXh0PjwlPSBAcGVyY2VudGFnZSAlPjwvVGV4dD5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcbiAgXG4gIEBpbXBsIHRydWVcbiAgZGVmIG1vdW50KF9wYXJhbXMsIF9zZXNzaW9uLCBzb2NrZXQpIGRvXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgOnBlcmNlbnRhZ2UsIDApfVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJzbGlkZVwiLCAle1wibXktc2xpZGVyXCIgPT4gdmFsdWV9LCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCA6cGVyY2VudGFnZSwgdmFsdWUpfVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,879],[968,49],[1019,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <LiveForm id="my-form" phx-change="slide">
      <Slider
        name="my-slider"
        lowerBound={0}
        upperBound={100}
        step={1}
      >
        <Text template={:minimumValueLabel}>0%</Text>
        <Text template={:maximumValueLabel}>100%</Text>
      </Slider>
    </LiveForm>
    <Text><%= @percentage %></Text>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :percentage, 0)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("slide", %{"my-slider" => value}, socket) do
    {:noreply, assign(socket, :percentage, value)}
  end
end
```

### Stepper

This code example renders a SwiftUI [Stepper](https://developer.apple.com/documentation/swiftui/stepper). It triggers the change event and sends a `"change-tickets"` message when the stepper increments or decrements. The `"change-tickets"` event handler then updates the number of tickets stored in state, which appears in the UI.

Evaluate the example and increment/decrement the step.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXZlRm9ybSBpZD1cIm15LWZvcm1cIj5cbiAgICAgIDxTdGVwcGVyXG4gICAgICAgIG5hbWU9XCJteS1zdGVwcGVyXCJcbiAgICAgICAgbG93ZXItYm91bmQ9ezB9XG4gICAgICAgIHVwcGVyLWJvdW5kPXsxNn1cbiAgICAgICAgc3RlcD17MX1cbiAgICAgICAgcGh4LWNoYW5nZT1cImNoYW5nZS10aWNrZXRzXCJcbiAgICAgID5cbiAgICAgICAgVGlja2V0cyA8JT0gQHRpY2tldHMgJT5cbiAgICAgIDwvU3RlcHBlcj5cbiAgICA8L0xpdmVGb3JtPlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuXG4gIEBpbXBsIHRydWVcbiAgZGVmIG1vdW50KF9wYXJhbXMsIF9zZXNzaW9uLCBzb2NrZXQpIGRvXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgOnRpY2tldHMsIDApfVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJjaGFuZ2UtdGlja2V0c1wiLCAle1wibXktc3RlcHBlclwiID0+IHRpY2tldHN9LCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCA6dGlja2V0cywgdGlja2V0cyl9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,792],[881,49],[932,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <LiveForm id="my-form">
      <Stepper
        name="my-stepper"
        lower-bound={0}
        upper-bound={16}
        step={1}
        phx-change="change-tickets"
      >
        Tickets <%= @tickets %>
      </Stepper>
    </LiveForm>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tickets, 0)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("change-tickets", %{"my-stepper" => tickets}, socket) do
    {:noreply, assign(socket, :tickets, tickets)}
  end
end
```

### Toggle

This code example renders a SwiftUI [Toggle](https://developer.apple.com/documentation/swiftui/toggle). It triggers the change event and sends a `"toggle"` message when toggled. The `"toggle"` event handler then updates the `:on` field in state, which allows the `Toggle` view to be toggled o through the `isOn` attribute.

Evaluate the example below and click on the toggle.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXZlRm9ybSBpZD1cIm15LWZvcm1cIiBwaHgtY2hhbmdlPVwidG9nZ2xlXCI+XG4gICAgICA8VG9nZ2xlIGlzT249e0Bvbn0gbmFtZT1cIm15LXRvZ2dsZVwiPk9uL09mZjwvVG9nZ2xlPlxuICAgIDwvTGl2ZUZvcm0+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICB7Om9rLCBhc3NpZ24oc29ja2V0LCA6b24sIGZhbHNlKX1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgaGFuZGxlX2V2ZW50KFwidG9nZ2xlXCIsICV7XCJteS10b2dnbGVcIiA9PiBvbn0sIHNvY2tldCkgZG9cbiAgICB7Om5vcmVwbHksIGFzc2lnbihzb2NrZXQsIDpvbiwgb24pfVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,645],[734,49],[785,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <LiveForm id="my-form" phx-change="toggle">
      <Toggle isOn={@on} name="my-toggle">On/Off</Toggle>
    </LiveForm>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :on, false)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("toggle", %{"my-toggle" => on}, socket) do
    {:noreply, assign(socket, :on, on)}
  end
end
```

### DatePicker

The SwiftUI Date Picker provides a native view for selecting a date. The date is selected by the user and sent back as a string. Evaluate the example below and select a date to see the date params appear in the console below.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXZlRm9ybSBpZD1cIm15LWZvcm1cIiBwaHgtY2hhbmdlPVwicGljay1kYXRlXCI+XG4gICAgICA8RGF0ZVBpY2tlciBuYW1lPVwibXktZGF0ZS1waWNrZXJcIi8+XG4gICAgPC9MaXZlRm9ybT5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcbiAgcmVxdWlyZSBMb2dnZXJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBtb3VudChfcGFyYW1zLCBfc2Vzc2lvbiwgc29ja2V0KSBkb1xuICAgIHs6b2ssIGFzc2lnbihzb2NrZXQsIDpkYXRlLCBuaWwpfVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJwaWNrLWRhdGVcIiwgcGFyYW1zLCBzb2NrZXQpIGRvXG4gICAgTG9nZ2VyLmluZm8oXCJEYXRlIFBhcmFtczogI3tpbnNwZWN0KHBhcmFtcyl9XCIpXG4gICAgezpub3JlcGx5LCBzb2NrZXR9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,672],[761,49],[812,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <LiveForm id="my-form" phx-change="pick-date">
      <DatePicker name="my-date-picker"/>
    </LiveForm>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :date, nil)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("pick-date", params, socket) do
    Logger.info("Date Params: #{inspect(params)}")
    {:noreply, socket}
  end
end
```

### Parsing Dates

The date from the `DatePicker` is in iso8601 format. You can use the `from_iso8601` function to parse this string into a `DateTime` struct.

```elixir
iso8601 = "2024-01-17T20:51:00.000Z"

DateTime.from_iso8601(iso8601)
```

### Your Turn: Displayed Components

The `DatePicker` view accepts a `displayedComponents` attribute with the value of `"hourAndMinute"` or `"date"` to only display one of the two components. By default, the value is `"all"`.

You're going to change the `displayedComponents` attribute in the example below to see both of these options. Change `"all"` to `"date"`, then to `"hourAndMinute"`. Re-evaluate the cell between changes and see the updated UI.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXZlRm9ybSBpZD1cIm15LWZvcm1cIiBwaHgtY2hhbmdlPVwicGljay1kYXRlXCI+XG4gICAgICA8RGF0ZVBpY2tlciBkaXNwbGF5ZWRDb21wb25lbnRzPVwiZGF0ZVwiIG5hbWU9XCJteS1kYXRlLXBpY2tlclwiIC8+XG4gICAgPC9MaXZlRm9ybT5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJwaWNrLWRhdGVcIiwgX3BhcmFtcywgc29ja2V0KSBkb1xuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,533],[622,49],[673,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <LiveForm id="my-form" phx-change="pick-date">
      <DatePicker displayedComponents="date" name="my-date-picker" />
    </LiveForm>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("pick-date", _params, socket) do
    {:noreply, socket}
  end
end
```

## Small Project: Todo List

Using the previous examples as inspiration, you're going to create a todo list.

**Requirements**

* Items should be `Text` views rendered within a `List` view.
* Item ids should be stored in state as a list of integers i.e. `[1, 2, 3, 4]`
* Use a `TextField` to provide the name of the next added todo item.
* An add item `Button` should add items to the list of integers in state when pressed.
* A delete item `Button` should remove the currently selected item from the list of integers in state when pressed.

### Example Solution

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <LiveForm id="my-form" phx-change="type-name" >
      <TextField name="text" text={@item_name}>Todo...</TextField>
    </LiveForm>
    <Button phx-click="add-item">Add Item</Button>
    <Button phx-click="delete-item">Delete Item</Button>
    <List selection={@selection} phx-change="selection-changed">
      <Text id={id} :for={{id, content} <- @items}><%= content %></Text>
    </List>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, items: [], selection: "None", item_name: "", next_item_id: 1)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("type-name", %{"text" => name}, socket) do
    {:noreply, assign(socket, :item_name, name)}
  end

  def handle_event("add-item", _params, socket) do
    updated_items = [
      {"item-#{socket.assigns.next_item_id}", socket.assigns.item_name}
      | socket.assigns.items
    ]

    {:noreply,
     assign(socket,
       item_name: "",
       items: updated_items,
       next_item_id: socket.assigns.next_item_id + 1
     )}
  end

  def handle_event("delete-item", _params, socket) do
    updated_items =
      Enum.reject(socket.assigns.items, fn {id, _name} -> id == socket.assigns.selection end)
    {:noreply, assign(socket, :items, updated_items)}
  end

  def handle_event("selection-changed", %{"selection" => selection}, socket) do
    {:noreply, assign(socket, selection: selection)}
  end
end
```



<!-- livebook:{"break_markdown":true} -->

### Enter Your Solution Below

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnKSBkb1xuICAgIH5MVk5cIlwiXCJcbiAgICA8IS0tIEVudGVyIHlvdXIgc29sdXRpb24gYmVsb3cgLS0+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgIyBEZWZpbmUgeW91ciBtb3VudC8zIGNhbGxiYWNrXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5cbiAgIyBEZWZpbmUgeW91ciByZW5kZXIvMyBjYWxsYmFja1xuXG4gICMgRGVmaW5lIGFueSBoYW5kbGVfZXZlbnQvMyBjYWxsYmFja3NcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,448],[537,49],[588,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assig) do
    ~LVN"""
    <!-- Enter your solution below -->
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  # Define your mount/3 callback

  @impl true
  def render(assigns), do: ~H""

  # Define your render/3 callback

  # Define any handle_event/3 callbacks
end
```
