defmodule LiveViewNative.SwiftUI do
  use LiveViewNativePlatform

  def platforms,
    do: [
      LiveViewNative.SwiftUI.Platform
    ]
end
