defmodule LiveViewNativeSwiftUi.Modifiers.ForegroundColor do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "foreground_color" do
    field :color, Color
  end

  def params(%Color{} = color), do: [color: color]
  def params(params) when is_list(params) or is_map(params), do: params
  def params(color), do: [color: color]
end
