defmodule LiveViewNativeSwiftUi.Modifiers.IndexViewStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "index_view_style" do
    field :style, Ecto.Enum, values: ~w(page page_always page_automatic page_interactive page_never)a
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
