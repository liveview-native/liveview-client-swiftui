# Getting Started

See how to quickly get up and running displaying a LiveView in your app.

## First Steps

Getting started with LiveViewNative is easy: simply create a ``LiveViewCoordinator`` and pass it into a ``LiveView`` that's part of your view tree.

The coordinator object is responsible for connecting to the Phoenix LiveView backend, managing the network connection, and sending and responding to events.

Only one coordinator may be used for a view, so use `@State` to store it on the containing view.

The only information you are required to provide is the URL of the live view to connect to.

The LiveView is then created by passing in the coordinator, no other setup necessary.

```swift
@MainActor
struct ContentView: View {
    @State private var coordinator = LiveViewCoordinator(URL(string: "http://localhost:4000/")!)

    var body: some View {
        LiveView(coordinator: coordinator)
    }
}
```

## Configuring the Coordinator

The coordinator can be configured with a number of different options. To customize these, create a ``LiveViewConfiguration`` with the values you want, and then pass it to coordinator's initializer.

```swift
@MainActor
struct ContentView: View {
    @State private var coordinator: LiveViewCoordinator<EmptyRegistry> = {
        var config = LiveViewConfiguration()
        config.navigationMode = .enabled
        return LiveViewCoordinator(URL(string: "http://localhost:4000/")!, config: config)
    }()

    var body: some View {
        LiveView(coordinator: coordinator)
    }
}
```

## Supporting Custom Elements

You can enable support for your own custom HTML elements and attributes by implementing the ``CustomRegistry`` protocol and providing it to the coordinator. The protocol uses only static methods, so rather than constructing an instance of your registry, you provide it as a generic type to the coordinator when constructing it:

```swift
@MainActor
struct ContentView: View {
    @State private var coordinator = LiveViewCoordinator<MyCustomRegistry>(URL(string: "http://localhost:4000/")!)

    var body: some View {
        LiveView(coordinator: coordinator)
    }
}
```
