# Navigation
The [`navigationPath`](https://github.com/liveview-native/liveview-client-swiftui/blob/0e0fc6bbe5e95ef308e51551af0889acb09b87b3/Sources/LiveViewNative/Coordinators/LiveSessionCoordinator.swift#L43) is handled by the `LiveSessionCoordinator`. The `LiveViewCoordinator` receives navigation events from the Phoenix LiveView over the channel, and [sends the navigation request to the session coordinator](https://github.com/liveview-native/liveview-client-swiftui/blob/0e0fc6bbe5e95ef308e51551af0889acb09b87b3/Sources/LiveViewNative/Coordinators/LiveSessionCoordinator.swift#L353).

## Kinds
There are two styles of navigation, based on how they impact the `window.history` on the browser.

### `push`
This style appends a history entry.

In the case of SwiftUI, this means there is a system page push animation, and a back button is available to navigate to the previous page.

### `replace`
This style replaces the current history entry.

In the case of SwiftUI, this means the top-most entry in the `navigationPath` is replaced with the new route. No back button is available to return to the previous page.

## Events
There are three main navigation events in Phoenix LiveView.

> When reconnecting on a new channel, the `redirect` key is used instead of the `url` key in the [connect params](https://github.com/liveview-native/liveview-client-swiftui/blob/9895c3b16d84a2683dcb1f127994be6c1bdf4919/Sources/LiveViewNative/Coordinators/LiveViewCoordinator.swift#L238).

### `redirect`
This method sends a `redirect` event.

```json
"redirect": {
    "to": "<path>"
}
```

This performs a `push` style navigation.

The channel is closed and a new channel connects on the same socket.

### `push_navigate`
This method sends a `live_redirect` event.

```json
"live_redirect": {
    "kind": "<push|replace>",
    "to": "<path>"
}
```

The channel is closed and a new channel connects on the same socket.

### `push_patch`
This method sends a `live_patch` event.

```json
{
    "kind": "<push|replace>",
    "to": "<path>"
}
```

The channel persists, unlike other forms of navigation. Only the query parameters of the URL are changed.