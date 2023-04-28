defmodule LiveViewNativeSwiftUi.Modifiers.ScrollBounceBehavior do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_bounce_behavior" do
    field :behavior, Ecto.Enum, values: ~w(automatic always based_on_size)a
    field :axes, Ecto.Enum, values: [:horizontal, :vertical, :all], default: :vertical
  end
end
