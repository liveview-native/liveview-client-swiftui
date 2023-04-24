defmodule LiveViewNativeSwiftUi.Modifiers.ListSectionSeparator do
  use LiveViewNativePlatform.Modifier

  modifier_schema "list_section_separator" do
    field :visibility, Ecto.Enum, values: ~w(automatic hidden visible)a
    field :edges, Ecto.Enum, values: ~w(all bottom top)a, default: :all
  end
end
