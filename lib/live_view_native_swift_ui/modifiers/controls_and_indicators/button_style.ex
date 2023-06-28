defmodule LiveViewNativeSwiftUi.Modifiers.ButtonStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "button_style" do
    field(:style, Ecto.Enum, values: ~w(
      automatic
      bordered
      bordered_prominent
      borderless
      plain
    )a)
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
