defmodule LiveViewNativeSwiftUi.Modifiers.ButtonStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "button_style" do
    field(:style, Ecto.Enum, values: ~w(
      automatic
      bordered
      bordered_prominent
      borderless
      plain
    )a)
  end
end
