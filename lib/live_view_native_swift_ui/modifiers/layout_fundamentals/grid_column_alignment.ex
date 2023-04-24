defmodule LiveViewNativeSwiftUi.Modifiers.GridColumnAlignment do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grid_column_alignment" do
    field :guide, Ecto.Enum, values: [:leading, :center, :trailing]
  end
end
