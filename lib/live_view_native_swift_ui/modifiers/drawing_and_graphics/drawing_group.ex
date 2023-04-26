defmodule LiveViewNativeSwiftUi.Modifiers.DrawingGroup do
  use LiveViewNativePlatform.Modifier

  modifier_schema "drawing_group" do
    field :opaque, :boolean, default: false
    field :color_mode, Ecto.Enum, values: ~w(extended_linear, linear, non_linear)a, default: :non_linear
  end
end
