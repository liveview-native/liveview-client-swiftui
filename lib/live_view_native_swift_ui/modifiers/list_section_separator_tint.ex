defmodule LiveViewNativeSwiftUi.Modifiers.ListSectionSeparatorTint do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "list_section_separator_tint" do
    field :color, Color
    field :edges, Ecto.Enum, values: ~w(all bottom top)a, default: :all
  end
end
