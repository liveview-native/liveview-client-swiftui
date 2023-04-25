defmodule LiveViewNativeSwiftUi.Modifiers.ScaleEffect do
  use LiveViewNativePlatform.Modifier
  
  alias LiveViewNativeSwiftUi.Types.UnitPoint
  
  modifier_schema "scale_effect" do
    field :scale, {:array, :float}, default: [1.0, 1.0]
    field :anchor, UnitPoint
  end
end
