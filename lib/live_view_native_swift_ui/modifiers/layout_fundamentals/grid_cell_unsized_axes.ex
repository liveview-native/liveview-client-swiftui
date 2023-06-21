defmodule LiveViewNativeSwiftUi.Modifiers.GridCellUnsizedAxes do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grid_cell_unsized_axes" do
    field :axes, Ecto.Enum, values: [:horizontal, :vertical, :all]
  end

  def params(axes) when is_atom(axes), do: [axes: axes]
  def params(params), do: params
end
