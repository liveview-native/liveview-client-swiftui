defmodule LiveViewNativeSwiftUi.Modifiers.Interpolation do
  use LiveViewNativePlatform.Modifier

  modifier_schema "interpolation" do
    field :interpolation, Ecto.Enum, values: ~w(low medium high none)a
  end
end
