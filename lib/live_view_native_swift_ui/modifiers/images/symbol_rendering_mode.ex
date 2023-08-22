defmodule LiveViewNativeSwiftUi.Modifiers.SymbolRenderingMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "symbol_rendering_mode" do
    field :mode, Ecto.Enum, values: ~w(hierarchical monochrome multicolor palette)a
  end

  def params(mode) when is_atom(mode) and not is_boolean(mode) and not is_nil(mode), do: [mode: mode]
  def params(params), do: params
end
