defmodule LiveViewNativeSwiftUi.Modifiers.ToggleStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "toggle_style" do
    field(:style, Ecto.Enum, values: ~w(
      automatic
      button
      switch
      checkbox
    )a)
  end
end
