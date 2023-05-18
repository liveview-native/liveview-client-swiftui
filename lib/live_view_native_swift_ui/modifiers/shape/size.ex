defmodule LiveViewNativeSwiftUi.Modifiers.Size do
  use LiveViewNativePlatform.Modifier

  modifier_schema "size" do
    field :width, :float, default: 0.0
    field :height, :float, default: 0.0
  end
end
