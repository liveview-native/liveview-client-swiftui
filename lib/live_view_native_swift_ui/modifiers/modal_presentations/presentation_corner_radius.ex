defmodule LiveViewNativeSwiftUi.Modifiers.PresentationCornerRadius do
  use LiveViewNativePlatform.Modifier

  modifier_schema "presentation_corner_radius" do
    field(:radius, :float)
  end

  def params(radius) when is_number(radius), do: [radius: radius]
  def params(params), do: params
end
