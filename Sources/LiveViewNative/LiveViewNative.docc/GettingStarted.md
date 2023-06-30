# Getting Started

See how to quickly get up and running displaying a LiveView in your app.

## First Steps

Getting started with LiveViewNative is easy: simply use a ``LiveView`` as part of your view tree, and pass a ``LiveViewHost`` to launch.

This can be ``LocalhostLiveViewHost/localhost``, some other ``AutomaticLiveViewHost/automatic(development:production:)``, or any `URL` with ``LiveView/init(url:configuration:)``.

```swift
@MainActor
struct ContentView: View {
    var body: some View {
        LiveView(.localhost)
    }
}
```

## Configuring the LiveView

The ``LiveView`` can be configured with a number of different options. To customize these, create a ``LiveSessionConfiguration`` with the values you want, and then pass it to view's initializer.

```swift
@MainActor
struct ContentView: View {
    @State private var session: LiveSessionCoordinator<EmptyRegistry> = {
        var config = LiveSessionConfiguration()
        config.navigationMode = .enabled
        return LiveSessionCoordinator(URL(string: "http://localhost:4000/")!, config: config)
    }()

    var body: some View {
        LiveView(
            .localhost,
            configuration: LiveSessionConfiguration(navigationMode: .enabled)
        )
    }
}
```

## Supporting Custom Elements

You can enable support for your own custom HTML elements and attributes by implementing the ``CustomRegistry`` protocol and providing it to the coordinator. The protocol uses only static methods, so rather than constructing an instance of your registry, you provide it as a generic type to the ``LiveView`` when constructing it:

```swift
@MainActor
struct ContentView: View {
    var body: some View {
        LiveView<MyCustomRegistry>(.localhost)
    }
}
```

## Accessing the ``LiveSessionCoordinator``

``LiveSessionCoordinator`` handles everything needed to connect and run a ``LiveView``. When you pass a ``LiveViewHost`` or `URL` in the initializer, this coordinator is created for you.

However, in some cases you may want access to this coordinator to send or receive custom events. In these cases, create the ``LiveSessionCoordinator`` yourself, and pass it to ``LiveView/init(session:)``.

```swift
struct ContentView: View {
    @StateObject private var session = LiveSessionCoordinator<MyCustomRegistry>(.localhost)

    var body: some View {
        LiveView(session: session)
    }
}
```

Now you have full access to the ``LiveSessionCoordinator`` and all of its properties and methods.
