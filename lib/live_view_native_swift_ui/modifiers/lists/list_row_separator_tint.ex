defmodule LiveViewNativeSwiftUi.Modifiers.ListRowSeparatorTint do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "list_row_separator_tint" do
    field :color, Color
    field :edges, Ecto.Enum, values: ~w(all bottom top)a, default: :all
  end

  def params(color, [edges: edges]), do: [color: color, edges: edges]
  def params(params) do
    with {:ok, _} <- Color.cast(params) do
      [color: params]
    else
      _ ->
        params
    end
  end
end
