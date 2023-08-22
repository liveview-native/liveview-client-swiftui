defmodule LiveViewNativeSwiftUi.Modifiers.LabelStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "label_style" do
    field :style, Ecto.Enum, values: ~w(automatic icon_only title_and_icon title_only)a
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
