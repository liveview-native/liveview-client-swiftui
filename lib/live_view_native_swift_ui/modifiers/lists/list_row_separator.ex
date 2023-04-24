defmodule LiveViewNativeSwiftUi.Modifiers.ListRowSeparator do
  use LiveViewNativePlatform.Modifier

  modifier_schema "list_row_separator" do
    field :visibility, Ecto.Enum, values: ~w(automatic visible hidden)a
    field :edges, Ecto.Enum, values: ~w(all bottom top)a
  end
end
