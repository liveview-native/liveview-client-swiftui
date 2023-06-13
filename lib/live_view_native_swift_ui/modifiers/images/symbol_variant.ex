defmodule LiveViewNativeSwiftUi.Modifiers.SymbolVariant do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.SymbolVariants

  modifier_schema "symbol_variant" do
    field :variant, SymbolVariants
  end
end
