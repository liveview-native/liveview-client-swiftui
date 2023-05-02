defmodule LiveViewNativeSwiftUi.Modifiers.DisclosureGroupStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "disclosure_group_style" do
    field :style, Ecto.Enum, values: ~w(automatic)a
  end
end
