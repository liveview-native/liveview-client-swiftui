defmodule LiveViewNativeSwiftUi.Modifiers.TabViewStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "tab_view_style" do
    field :style, Ecto.Enum, values: ~w(automatic carousel page page_always page_never)a
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
