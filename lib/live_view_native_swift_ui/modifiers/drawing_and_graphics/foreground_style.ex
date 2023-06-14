defmodule LiveViewNativeSwiftUi.Modifiers.ForegroundStyle do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "foreground_style" do
    field :primary, ShapeStyle
    field :secondary, ShapeStyle
    field :tertiary, ShapeStyle
  end

  def params(%ShapeStyle{} = primary), do: [primary: primary]
  def params(params) when is_list(params) or is_map(params), do: params
  def params(primary), do: [primary: primary]
  def params(primary, secondary), do: [primary: primary, secondary: secondary]
  def params(primary, secondary, tertiary), do: [primary: primary, secondary: secondary, tertiary: tertiary]
end
