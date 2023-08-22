defmodule LiveViewNativeSwiftUi.Modifiers.CornerRadius do
  use LiveViewNativePlatform.Modifier

  modifier_schema "corner_radius" do
    field(:radius, :float)
    field(:antialiased, :boolean, default: true)
  end

  def params(radius, [antialiased: antialiased]), do: [radius: radius, antialiased: antialiased]
  def params(radius) when is_number(radius), do: [radius: radius]
  def params(params), do: params
end
