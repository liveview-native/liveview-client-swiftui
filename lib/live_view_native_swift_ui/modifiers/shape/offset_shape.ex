defmodule LiveViewNativeSwiftUi.Modifiers.OffsetShape do
  use LiveViewNativePlatform.Modifier

  modifier_schema "offset_shape" do
    field :x, :float, default: 0.0
    field :y, :float, default: 0.0
  end
end
