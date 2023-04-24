defmodule LiveViewNativeSwiftUi.Modifiers.FontWeight do
  use LiveViewNativePlatform.Modifier

  modifier_schema "font_weight" do
    field :weight, Ecto.Enum, values: ~w(
      black
      bold
      heavy
      light
      medium
      regular
      semibold
      thin
      ultra_light
    )a
  end
end
