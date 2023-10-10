defmodule LiveViewNative.SwiftUI do
  use LiveViewNativePlatform

  def platforms,
    do: [
      LiveViewNativeSwiftUi.Platform
    ]
end
