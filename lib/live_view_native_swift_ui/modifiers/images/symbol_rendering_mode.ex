defmodule LiveViewNativeSwiftUi.Modifiers.SymbolRenderingMode do
  use LiveViewNativePlatform.Modifier

  modifier_schema "symbol_rendering_mode" do
    field :mode, Ecto.Enum, values: ~w(hierarchical monochrome multicolor palette)a
  end
end
