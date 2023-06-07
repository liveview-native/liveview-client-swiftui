defmodule LiveViewNativeSwiftUi.Modifiers.ScaleEffect do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.UnitPoint

  modifier_schema "scale_effect" do
    field :x, :float
    field :y, :float
    field :scale, {:array, :float}
    field :anchor, UnitPoint
  end
end
