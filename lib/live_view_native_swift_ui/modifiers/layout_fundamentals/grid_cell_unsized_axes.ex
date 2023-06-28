defmodule LiveViewNativeSwiftUi.Modifiers.GridCellUnsizedAxes do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grid_cell_unsized_axes" do
    field :axes, Ecto.Enum, values: [:horizontal, :vertical, :all]
  end

  def params(axes) when is_atom(axes) and not is_boolean(axes) and not is_nil(axes), do: [axes: axes]
  def params(params), do: params
end
