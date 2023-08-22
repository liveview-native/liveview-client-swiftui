defmodule LiveViewNativeSwiftUi.Modifiers.SymbolVariant do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.SymbolVariants

  modifier_schema "symbol_variant" do
    field :variant, SymbolVariants
  end

  def params(params) do
    with {:ok, _} <- SymbolVariants.cast(params) do
      [variant: params]
    else
      _ ->
        params
    end
  end
end
