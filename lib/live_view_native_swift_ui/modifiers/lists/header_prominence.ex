defmodule LiveViewNativeSwiftUi.Modifiers.HeaderProminence do
  use LiveViewNativePlatform.Modifier

  modifier_schema "header_prominence" do
    field :prominence, Ecto.Enum, values: ~w(increased standard)a
  end
end