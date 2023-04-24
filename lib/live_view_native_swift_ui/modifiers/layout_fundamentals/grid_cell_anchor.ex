defmodule LiveViewNativeSwiftUi.Modifiers.GridCellAnchor do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grid_cell_anchor" do
    field :anchor, LiveViewNativeSwiftUi.Types.UnitPoint
  end
end
