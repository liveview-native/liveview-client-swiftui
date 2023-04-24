defmodule LiveViewNativeSwiftUi.Modifiers.IndexViewStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "index_view_style" do
    field :style, Ecto.Enum, values: ~w(page page_always page_automatic page_interactive page_never)a
  end
end
