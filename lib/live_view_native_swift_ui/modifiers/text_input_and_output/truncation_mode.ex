defmodule LiveViewNativeSwiftUi.Modifiers.TruncationMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "truncation_mode" do
    field :mode, Ecto.Enum, values: ~w(
      head
      middle
      tail
    )a
  end
end
