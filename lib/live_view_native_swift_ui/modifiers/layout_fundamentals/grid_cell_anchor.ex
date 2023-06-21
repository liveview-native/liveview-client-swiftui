defmodule LiveViewNativeSwiftUi.Modifiers.GridCellAnchor do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.UnitPoint

  modifier_schema "grid_cell_anchor" do
    field :anchor, UnitPoint
  end

  def params(params) do
    with {:ok, _} <- UnitPoint.cast(params) do
      [anchor: params]
    else
      _ ->
        params
    end
  end
end
