defmodule LiveViewNativeSwiftUi.Modifiers.ScaleEffect do
  use LiveViewNativePlatform.Modifier
  
  alias LiveViewNativeSwiftUi.Types.UnitPoint
  
  modifier_schema "scale_effect" do
    field :width, :float, default: 1.0
    field :height, :float, default: 1.0
    field :anchor, UnitPoint
  end
end
