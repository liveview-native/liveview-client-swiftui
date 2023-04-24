defmodule LiveViewNativeSwiftUi.Modifiers.Strikethrough do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "strikethrough" do
    field :is_active, :boolean, default: true
    field :pattern, Ecto.Enum, values: ~w(dash dash_dot dash_dot_dot dot solid)a, default: :solid
    field :color, Color
  end
end
