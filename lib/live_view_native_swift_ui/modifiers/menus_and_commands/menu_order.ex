defmodule LiveViewNativeSwiftUi.Modifiers.MenuOrder do
  use LiveViewNativePlatform.Modifier

  modifier_schema "menu_order" do
    field(:order, Ecto.Enum, values: ~w(automatic fixed priority)a)
  end
end
