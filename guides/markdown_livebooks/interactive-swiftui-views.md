# Interactive SwiftUI Views

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fraw.githubusercontent.com%2Fliveview-native%liveview-client-swiftui%2Fmain%2Fguides%livebooks%interactive-swiftui-views.livemd)

## Overview

In this guide, you'll learn how to build interactive LiveView Native applications using event bindings.

This guide assumes some existing familiarity with [Phoenix Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) and how to set/access state stored in the LiveView's socket assigns. To get the most out of this material, you should already understand the `assign/3`/`assign/2` function, and how event bindings such as `phx-click` interact with the `handle_event/3` callback function.

We'll use the following LiveView and define new render component examples throughout the guide.

<!-- livebook:{"attrs":"e30","chunks":[[0,85],[87,347],[436,49],[487,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

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

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxCdXR0b24gcGh4LWNsaWNrPVwicGluZ1wiPlByZXNzIG1lIG9uIG5hdGl2ZSE8L0J1dHRvbj5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJwaW5nXCIsIF9wYXJhbXMsIHNvY2tldCkgZG9cbiAgICBJTy5wdXRzKFwiUG9uZ1wiKVxuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,481],[570,49],[621,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
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

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxCdXR0b24gcGh4LWNsaWNrPVwiaW5jcmVtZW50XCI+Q291bnQ6IDwlPSBAY291bnQgJT48L0J1dHRvbj5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBtb3VudChfcGFyYW1zLCBfc2Vzc2lvbiwgc29ja2V0KSBkb1xuICAgIHs6b2ssIGFzc2lnbihzb2NrZXQsIDpjb3VudCwgMCl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcImluY3JlbWVudFwiLCBfcGFyYW1zLCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCA6Y291bnQsIHNvY2tldC5hc3NpZ25zLmNvdW50ICsgMSl9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,613],[702,49],[753,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
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

  def render(assigns, _interface) do
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

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwhLS0gRGlzcGxheXMgdGhlIGN1cnJlbnQgY291bnQgLS0+XG4gICAgPFRleHQ+PCU9IEBjb3VudCAlPjwvVGV4dD5cblxuICAgIDwhLS0gRW50ZXIgeW91ciBzb2x1dGlvbiBiZWxvdyAtLT5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBtb3VudChfcGFyYW1zLCBfc2Vzc2lvbiwgc29ja2V0KSBkb1xuICAgIHs6b2ssIGFzc2lnbihzb2NrZXQsIDpjb3VudCwgMCl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,523],[612,49],[663,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
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

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXN0IHNlbGVjdGlvbj17QHNlbGVjdGlvbn0gcGh4LWNoYW5nZT1cInNlbGVjdGlvbi1jaGFuZ2VkXCI+XG4gICAgICA8VGV4dCA6Zm9yPXtpIDwtIDEuLjEwfSBpZD17XCIje2l9XCJ9Pkl0ZW0gPCU9IGkgJT48L1RleHQ+XG4gICAgPC9MaXN0PlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuXG4gIEBpbXBsIHRydWVcbiAgZGVmIG1vdW50KF9wYXJhbXMsIF9zZXNzaW9uLCBzb2NrZXQpIGRvXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgc2VsZWN0aW9uOiBcIk5vbmVcIil9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInNlbGVjdGlvbi1jaGFuZ2VkXCIsICV7XCJzZWxlY3Rpb25cIiA9PiBzZWxlY3Rpb259LCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCBzZWxlY3Rpb246IHNlbGVjdGlvbil9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,713],[802,49],[853,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
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

To control a `DisclosureGroup` view, use the `is-expanded` boolean attribute as seen in the example below.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXN0PlxuICAgICAgPERpc2Nsb3N1cmVHcm91cCBwaHgtY2hhbmdlPVwidG9nZ2xlXCIgaXMtZXhwYW5kZWQ9e0Bpc19leHBhbmRlZH0+XG4gICAgICAgIDxUZXh0IHRlbXBsYXRlPVwibGFiZWxcIj5MZXZlbCAxPC9UZXh0PlxuICAgICAgICA8VGV4dD5JdGVtIDE8L1RleHQ+XG4gICAgICAgIDxUZXh0Pkl0ZW0gMjwvVGV4dD5cbiAgICAgICAgPFRleHQ+SXRlbSAzPC9UZXh0PlxuICAgICAgPC9EaXNjbG9zdXJlR3JvdXA+XG4gICAgPC9MaXN0PlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuXG4gIEBpbXBsIHRydWVcbiAgZGVmIG1vdW50KF9wYXJhbXMsIF9zZXNzaW9uLCBzb2NrZXQpIGRvXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgOmlzX2V4cGFuZGVkLCBmYWxzZSl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInRvZ2dsZVwiLCAle1wiaXMtZXhwYW5kZWRcIiA9PiBpc19leHBhbmRlZH0sIHNvY2tldCkgZG9cbiAgICB7Om5vcmVwbHksIGFzc2lnbihzb2NrZXQsIGlzX2V4cGFuZGVkOiAhaXNfZXhwYW5kZWQpfVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,822],[911,49],[962,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <List>
      <DisclosureGroup phx-change="toggle" is-expanded={@is_expanded}>
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
  def handle_event("toggle", %{"is-expanded" => is_expanded}, socket) do
    {:noreply, assign(socket, is_expanded: !is_expanded)}
  end
end
```

### Multiple Expandable Lists

The next example shows one pattern for displaying multiple expandable lists without needing to write multiple event handlers.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxMaXN0PlxuICAgICAgPERpc2Nsb3N1cmVHcm91cCBwaHgtY2hhbmdlPVwidG9nZ2xlLTFcIiBpcy1leHBhbmRlZD17QGV4cGFuZGVkX2dyb3Vwc1sxXX0+XG4gICAgICAgIDxUZXh0IHRlbXBsYXRlPVwibGFiZWxcIj5MZXZlbCAxPC9UZXh0PlxuICAgICAgICA8VGV4dD5JdGVtIDE8L1RleHQ+XG4gICAgICAgIDxEaXNjbG9zdXJlR3JvdXAgcGh4LWNoYW5nZT1cInRvZ2dsZS0yXCIgaXMtZXhwYW5kZWQ9e0BleHBhbmRlZF9ncm91cHNbMl19PlxuICAgICAgICAgIDxUZXh0IHRlbXBsYXRlPVwibGFiZWxcIj5MZXZlbCAyPC9UZXh0PlxuICAgICAgICAgIDxUZXh0Pkl0ZW0gMjwvVGV4dD5cbiAgICAgICAgPC9EaXNjbG9zdXJlR3JvdXA+XG4gICAgICA8L0Rpc2Nsb3N1cmVHcm91cD5cbiAgICA8L0xpc3Q+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICB7Om9rLCBhc3NpZ24oc29ja2V0LCA6ZXhwYW5kZWRfZ3JvdXBzLCAlezEgPT4gZmFsc2UsIDIgPT4gZmFsc2V9KX1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgaGFuZGxlX2V2ZW50KFwidG9nZ2xlLVwiIDw+IGxldmVsLCAle1wiaXMtZXhwYW5kZWRcIiA9PiBpc19leHBhbmRlZH0sIHNvY2tldCkgZG9cbiAgICBsZXZlbCA9IFN0cmluZy50b19pbnRlZ2VyKGxldmVsKVxuXG4gICAgezpub3JlcGx5LFxuICAgICBhc3NpZ24oXG4gICAgICAgc29ja2V0LFxuICAgICAgIDpleHBhbmRlZF9ncm91cHMsXG4gICAgICAgTWFwLnJlcGxhY2UhKHNvY2tldC5hc3NpZ25zLmV4cGFuZGVkX2dyb3VwcywgbGV2ZWwsICFpc19leHBhbmRlZClcbiAgICAgKX1cbiAgZW5kXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,1125],[1214,49],[1265,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <List>
      <DisclosureGroup phx-change="toggle-1" is-expanded={@expanded_groups[1]}>
        <Text template="label">Level 1</Text>
        <Text>Item 1</Text>
        <DisclosureGroup phx-change="toggle-2" is-expanded={@expanded_groups[2]}>
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
  def handle_event("toggle-" <> level, %{"is-expanded" => is_expanded}, socket) do
    level = String.to_integer(level)

    {:noreply,
     assign(
       socket,
       :expanded_groups,
       Map.replace!(socket.assigns.expanded_groups, level, !is_expanded)
     )}
  end
end
```

## Controls and Indicators

In Phoenix, the `phx-change` event must be applied to a parent form. However in SwiftUI there is no similar concept of forms. Instead, SwiftUI provides [Controls and Indicators](https://developer.apple.com/documentation/swiftui/controls-and-indicators) views. We can apply the `phx-change` binding to any of these views.

Once bound, the SwiftUI view will send a message to the LiveView anytime the control or indicator changes its value.

The params of the message are based on the name of the [Binding](https://developer.apple.com/documentation/swiftui/binding) argument of the view's initializer in SwiftUI.

<!-- livebook:{"break_markdown":true} -->

### Event Value Bindings

Many views use the `value` binding argument, so event params are generally sent as `%{"value" => value}`. However, certain views such as `TextField` and `Toggle` deviate from this pattern because SwiftUI uses a different `value` binding argument. For example, the `TextField` view uses `text` to bind its value, so it sends the event params as `%{"text" => value}`.

When in doubt, you can connect the event handler and inspect the params to confirm the shape of map.

## Text Field

The following example shows you how to connect a SwiftUI [TextField](https://developer.apple.com/documentation/swiftui/textfield) with a `phx-change` event binding to a corresponding event handler.

Evaluate the example and enter some text in your iOS simulator. Notice the inspected `params` appear in the server logs in the console below as a map of `%{"text" => value}`.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxUZXh0RmllbGQgcGh4LWNoYW5nZT1cInR5cGVcIj5FbnRlciB0ZXh0IGhlcmU8L1RleHRGaWVsZD5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJ0eXBlXCIsIHBhcmFtcywgc29ja2V0KSBkb1xuICAgIElPLmluc3BlY3QocGFyYW1zLCBsYWJlbDogXCJwYXJhbXNcIilcbiAgICB7Om5vcmVwbHksIHNvY2tldH1cbiAgZW5kXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,503],[592,49],[643,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <TextField phx-change="type">Enter text here</TextField>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("type", params, socket) do
    IO.inspect(params, label: "params")
    {:noreply, socket}
  end
end
```

### Storing TextField Values in the Socket

The following example demonstrates how to set/access a TextField's value by controlling it using the socket assigns.

This pattern is useful when rendering the TextField's value elsewhere on the page, using the `TextField` view's value in other event handler logic, or to set an initial value.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxUZXh0RmllbGQgcGh4LWNoYW5nZT1cInR5cGVcIiB0ZXh0PXtAdGV4dH0+RW50ZXIgdGV4dCBoZXJlPC9UZXh0RmllbGQ+XG4gICAgPEJ1dHRvbiBwaHgtY2xpY2s9XCJwcmV0dHktcHJpbnRcIj5Mb2cgVGV4dCBWYWx1ZTwvQnV0dG9uPlxuICAgIDxUZXh0PlRoZSBjdXJyZW50IHZhbHVlOiA8JT0gQHRleHQgJT48L1RleHQ+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICB7Om9rLCBhc3NpZ24oc29ja2V0LCA6dGV4dCwgXCJpbml0aWFsIHZhbHVlXCIpfVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJ0eXBlXCIsICV7XCJ0ZXh0XCIgPT4gdGV4dH0sIHNvY2tldCkgZG9cbiAgICB7Om5vcmVwbHksIGFzc2lnbihzb2NrZXQsIDp0ZXh0LCB0ZXh0KX1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgaGFuZGxlX2V2ZW50KFwicHJldHR5LXByaW50XCIsIF9wYXJhbXMsIHNvY2tldCkgZG9cbiAgICBJTy5wdXRzKFwiXCJcIlxuICAgID09PT09PT09PT09PT09PT09PVxuICAgICN7c29ja2V0LmFzc2lnbnMudGV4dH1cbiAgICA9PT09PT09PT09PT09PT09PT1cbiAgICBcIlwiXCIpXG5cbiAgICB7Om5vcmVwbHksIHNvY2tldH1cbiAgZW5kXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,927],[1016,49],[1067,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <TextField phx-change="type" text={@text}>Enter text here</TextField>
    <Button phx-click="pretty-print">Log Text Value</Button>
    <Text>The current value: <%= @text %></Text>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :text, "initial value")}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("type", %{"text" => text}, socket) do
    {:noreply, assign(socket, :text, text)}
  end

  @impl true
  def handle_event("pretty-print", _params, socket) do
    IO.puts("""
    ==================
    #{socket.assigns.text}
    ==================
    """)

    {:noreply, socket}
  end
end
```

## Slider

This code example renders a SwiftUI [Slider](https://developer.apple.com/documentation/swiftui/slider). It triggers the change event when the slider is moved and sends a `"slide"` message. The `"slide"` event handler then logs the value to the console.

Evaluate the example and enter some text in your iOS simulator. Notice the inspected `params` appear in the console below as a map of `%{"value" => value}`.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxTbGlkZXJcbiAgICAgIGxvd2VyLWJvdW5kPXswfVxuICAgICAgdXBwZXItYm91bmQ9ezEwfVxuICAgICAgc3RlcD17MX1cbiAgICAgIHBoeC1jaGFuZ2U9XCJzbGlkZVwiXG4gICAgPlxuICAgICAgPFRleHQgdGVtcGxhdGU9ezpsYWJlbH0+UGVyY2VudCBDb21wbGV0ZWQ8L1RleHQ+XG4gICAgICA8VGV4dCB0ZW1wbGF0ZT17OlwibWluaW11bS12YWx1ZS1sYWJlbFwifT4wJTwvVGV4dD5cbiAgICAgIDxUZXh0IHRlbXBsYXRlPXs6XCJtYXhpbXVtLXZhbHVlLWxhYmVsXCJ9PjEwMCU8L1RleHQ+XG4gICAgPC9TbGlkZXI+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgaGFuZGxlX2V2ZW50KFwic2xpZGVcIiwgcGFyYW1zLCBzb2NrZXQpIGRvXG4gICAgSU8uaW5zcGVjdChwYXJhbXMsIGxhYmVsOiBcIlNsaWRlIFBhcmFtc1wiKVxuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,735],[824,49],[875,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <Slider
      lower-bound={0}
      upper-bound={10}
      step={1}
      phx-change="slide"
    >
      <Text template={:label}>Percent Completed</Text>
      <Text template={:"minimum-value-label"}>0%</Text>
      <Text template={:"maximum-value-label"}>100%</Text>
    </Slider>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("slide", params, socket) do
    IO.inspect(params, label: "Slide Params")
    {:noreply, socket}
  end
end
```

## Stepper

This code example renders a SwiftUI [Stepper](https://developer.apple.com/documentation/swiftui/stepper). It triggers the change event and sends a `"change-tickets"` message when the stepper increments or decrements. The `"change-tickets"` event handler then updates the number of tickets stored in state, which appears in the UI.

Evaluate the example and increment/decrement the step.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxTdGVwcGVyXG4gICAgICBsb3dlci1ib3VuZD17MH1cbiAgICAgIHVwcGVyLWJvdW5kPXsxNn1cbiAgICAgIHN0ZXA9ezF9XG4gICAgICBwaHgtY2hhbmdlPVwiY2hhbmdlLXRpY2tldHNcIlxuICAgID5cbiAgICAgIFRpY2tldHMgPCU9IEB0aWNrZXRzICU+XG4gICAgPC9TdGVwcGVyPlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuXG4gIEBpbXBsIHRydWVcbiAgZGVmIG1vdW50KF9wYXJhbXMsIF9zZXNzaW9uLCBzb2NrZXQpIGRvXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgOnRpY2tldHMsIDApfVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJjaGFuZ2UtdGlja2V0c1wiLCAle1widmFsdWVcIiA9PiB0aWNrZXRzfSwgc29ja2V0KSBkb1xuICAgIHs6bm9yZXBseSwgYXNzaWduKHNvY2tldCwgOnRpY2tldHMsIHRpY2tldHMpfVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,713],[802,49],[853,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <Stepper
      lower-bound={0}
      upper-bound={16}
      step={1}
      phx-change="change-tickets"
    >
      Tickets <%= @tickets %>
    </Stepper>
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
  def handle_event("change-tickets", %{"value" => tickets}, socket) do
    {:noreply, assign(socket, :tickets, tickets)}
  end
end
```

## Toggle

This code example renders a SwiftUI [Toggle](https://developer.apple.com/documentation/swiftui/toggle). It triggers the change event and sends a `"toggle"` message when toggled. The `"toggle"` event handler then updates the `:on` field in state, which allows the `Toggle` view to be toggled on. Without providing the `is-on` attribute, the `Toggle` view could not be flipped on and off.

Evaluate the example below and click on the toggle.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxUb2dnbGUgcGh4LWNoYW5nZT1cInRvZ2dsZVwiIGlzT249e0Bvbn0+T24vT2ZmPC9Ub2dnbGU+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICB7Om9rLCBhc3NpZ24oc29ja2V0LCA6b24sIGZhbHNlKX1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgaGFuZGxlX2V2ZW50KFwidG9nZ2xlXCIsICV7XCJpcy1vblwiID0+IG9ufSwgc29ja2V0KSBkb1xuICAgIHs6bm9yZXBseSwgYXNzaWduKHNvY2tldCwgOm9uLCBvbil9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,590],[679,49],[730,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <Toggle phx-change="toggle" isOn={@on}>On/Off</Toggle>
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
  def handle_event("toggle", %{"is-on" => on}, socket) do
    {:noreply, assign(socket, :on, on)}
  end
end
```

## DatePicker

The SwiftUI Date Picker provides a native view for selecting a date. The date is selected by the user and sent back as a string.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxEYXRlUGlja2VyIHBoeC1jaGFuZ2U9XCJwaWNrLWRhdGVcIi8+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICB7Om9rLCBhc3NpZ24oc29ja2V0LCA6ZGF0ZSwgbmlsKX1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgaGFuZGxlX2V2ZW50KFwicGljay1kYXRlXCIsIHBhcmFtcywgc29ja2V0KSBkb1xuICAgIElPLmluc3BlY3QocGFyYW1zLCBsYWJlbDogXCJEYXRlIFBhcmFtc1wiKVxuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,593],[682,49],[733,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <DatePicker phx-change="pick-date"/>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :date, nil)}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("pick-date", params, socket) do
    IO.inspect(params, label: "Date Params")
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

The `DatePicker` view accepts a `displayed-components` attribute with the value of `"hour-and-minute"` or `"date"` to only display one of the two components. By default, the value is `"all"`.

You're going to change the `displayed-components` attribute in the example below to see both of these options. Change `"all"` to `"date"`, then to `"hour-and-minute"`. Re-evaluate the cell between changes and see the updated UI.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxEYXRlUGlja2VyIGRpc3BsYXllZC1jb21wb25lbnRzPVwiYWxsXCIgcGh4LWNoYW5nZT1cInBpY2stZGF0ZVwiLz5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBkZWYgaGFuZGxlX2V2ZW50KFwicGljay1kYXRlXCIsIHBhcmFtcywgc29ja2V0KSBkb1xuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,462],[551,49],[602,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
    ~LVN"""
    <DatePicker displayed-components="all" phx-change="pick-date"/>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""

  def handle_event("pick-date", params, socket) do
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

  def render(assigns, _interface) do
    ~LVN"""
    <TextField phx-change="type-name" text={@item_name}>Todo...</TextField>
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

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMsIF9pbnRlcmZhY2UpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwhLS0gRW50ZXIgeW91ciBzb2x1dGlvbiBiZWxvdyAtLT5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICAjIERlZmluZSB5b3VyIG1vdW50LzMgY2FsbGJhY2tcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICAjIERlZmluZSB5b3VyIHJlbmRlci8zIGNhbGxiYWNrXG5cbiAgIyBEZWZpbmUgYW55IGhhbmRsZV9ldmVudC8zIGNhbGxiYWNrc1xuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,462],[551,49],[602,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns, _interface) do
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
