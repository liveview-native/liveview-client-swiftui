defmodule LiveViewNativeSwiftUi.Modifiers.MenuIndicatorVisibility do
  use LiveViewNativePlatform.Modifier

  modifier_schema "menu_indicator_visibility" do
    field(:visibility, Ecto.Enum, values: ~w(automatic hidden visible)a)
  end
end
