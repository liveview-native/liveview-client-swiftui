defmodule LiveViewNativeSwiftUi.Modifiers.GridCellColumns do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grid_cell_columns" do
    field :count, :integer
  end

  def params(count) when is_number(count), do: [count: count]
  def params(params), do: params
end
