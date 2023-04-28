defmodule LiveViewNativeSwiftUi.Modifiers.ScrollIndicators do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_indicators" do
    field :visibility, Ecto.Enum, values: ~w(automatic hidden never visible)a
    field :axes, Ecto.Enum, values: [:horizontal, :vertical, :all], default: :all
  end
end
