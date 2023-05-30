defmodule LiveViewNativeSwiftUi.Modifiers.SymbolVariant do
  use LiveViewNativePlatform.Modifier

  modifier_schema "symbol_variant" do
    field :variant, Ecto.Enum, values: ~w(
        none
        circle
        square
        rectangle
        fill
        slash
    )a
  end
end
