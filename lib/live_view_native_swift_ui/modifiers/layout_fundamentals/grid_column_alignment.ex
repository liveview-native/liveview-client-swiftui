defmodule LiveViewNativeSwiftUi.Modifiers.GridColumnAlignment do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grid_column_alignment" do
    field :guide, Ecto.Enum, values: [:leading, :center, :trailing]
  end

  def params(guide) when is_atom(guide), do: [guide: guide]
  def params(params), do: params
end
