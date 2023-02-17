defmodule LiveViewNativeSwiftUi.Modifiers.GridCellColumns do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grid_cell_columns" do
    field :count, :integer
  end
end
