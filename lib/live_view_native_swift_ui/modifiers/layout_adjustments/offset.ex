defmodule LiveViewNativeSwiftUi.Modifiers.Offset do
  use LiveViewNativePlatform.Modifier

  modifier_schema "offset" do
    field :x, :float, default: 0.0
    field :y, :float, default: 0.0
  end
end
