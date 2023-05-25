defmodule LiveViewNativeSwiftUi.Modifiers.Redacted do
  use LiveViewNativePlatform.Modifier

  modifier_schema "redacted" do
    field :reason, Ecto.Enum, values: ~w(placeholder privacy)a
  end
end
