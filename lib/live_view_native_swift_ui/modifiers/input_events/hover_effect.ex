defmodule LiveViewNativeSwiftUi.Modifiers.HoverEffect do
  use LiveViewNativePlatform.Modifier

  modifier_schema "hover_effect" do
    field :effect, Ecto.Enum, values: ~w(automatic highlight lift)a, default: :automatic
  end
end
