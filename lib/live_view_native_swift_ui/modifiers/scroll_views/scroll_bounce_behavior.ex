defmodule LiveViewNativeSwiftUi.Modifiers.ScrollBounceBehavior do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_bounce_behavior" do
    field :behavior, Ecto.Enum, values: ~w(automatic always based_on_size)a
    field :axes, Ecto.Enum, values: [:horizontal, :vertical, :all], default: :vertical
  end

  def params(behavior, params) when is_list(params), do: [{:behavior, behavior} | params]
  def params(behavior) when is_atom(behavior) and not is_boolean(behavior) and not is_nil(behavior), do: [behavior: behavior]
  def params(params), do: params
end
