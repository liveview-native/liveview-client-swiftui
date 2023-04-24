defmodule LiveViewNativeSwiftUi.Modifiers.TabViewStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "tab_view_style" do
    field :style, Ecto.Enum, values: ~w(automatic carousel page page_always page_never)a
  end
end
