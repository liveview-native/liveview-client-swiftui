defmodule LiveViewNativeSwiftUi.Modifiers.CornerRadius do
  use LiveViewNativePlatform.Modifier

  modifier_schema "corner_radius" do
    field(:radius, :float)
    field(:antialiased, :boolean, default: true)
  end
end
