defmodule LiveViewNativeSwiftUi.Modifiers.GroupBoxStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "group_box_style" do
    field :style, Ecto.Enum, values: ~w(automatic)a
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
