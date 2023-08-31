defmodule LiveViewNativeSwiftUi.Modifiers.ListStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "list_style" do
    field :style, Ecto.Enum, values: ~w(automatic bordered bordered_alternating carousel elliptical grouped inset inset_grouped inset_alternating plain sidebar)a
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
