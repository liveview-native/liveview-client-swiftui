defmodule LiveViewNativeSwiftUi.Modifiers.HoverEffect do
  use LiveViewNativePlatform.Modifier

  modifier_schema "hover_effect" do
    field :effect, Ecto.Enum, values: ~w(automatic highlight lift)a, default: :automatic
  end

  def params(effect) when is_atom(effect) and not is_boolean(effect) and not is_nil(effect), do: [effect: effect]
  def params(params), do: params
end
