defmodule LiveViewNativeSwiftUi do
  use LiveViewNativePlatform

  def platforms,
    do: [
      LiveViewNativeSwiftUi.Platform
    ]
end
