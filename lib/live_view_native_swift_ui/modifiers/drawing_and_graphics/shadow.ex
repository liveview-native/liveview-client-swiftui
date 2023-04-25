defmodule LiveViewNativeSwiftUi.Modifiers.Shadow do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "shadow" do
    field :color, Color
    field :radius, :float
    field :x, :float, default: 0.0
    field :y, :float, default: 0.0
  end
end

