defmodule LiveViewNativeSwiftUi.Modifiers.ListStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "list_style" do
    field :style, Ecto.Enum, values: ~w(automatic bordered bordered_alternating carousel elliptical grouped inset inset_grouped inset_alternating plain sidebar)a
  end
end
