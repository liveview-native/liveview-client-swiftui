defmodule LiveViewNativeSwiftUi.Modifiers.MenuStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "menu_style" do
    field(:style, Ecto.Enum, values: ~w(automatic button)a)
  end
end
