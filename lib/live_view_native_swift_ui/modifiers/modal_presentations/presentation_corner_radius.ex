defmodule LiveViewNativeSwiftUi.Modifiers.PresentationCornerRadius do
  use LiveViewNativePlatform.Modifier

  modifier_schema "presentation_corner_radius" do
    field(:radius, :float)
  end
end
