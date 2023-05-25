defmodule LiveViewNativeSwiftUi.Modifiers.TableStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "table_style" do
    field :style, Ecto.Enum, values: ~w(
        automatic
        inset
        inset_alternates_row_backgrounds
        bordered
        bordered_alternates_row_backgrounds
    )a
  end
end
