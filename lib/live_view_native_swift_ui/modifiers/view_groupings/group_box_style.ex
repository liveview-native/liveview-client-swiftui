defmodule LiveViewNativeSwiftUi.Modifiers.GroupBoxStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "group_box_style" do
    field :style, Ecto.Enum, values: ~w(automatic)a
  end
end
