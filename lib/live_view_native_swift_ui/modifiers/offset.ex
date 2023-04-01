defmodule LiveViewNativeSwiftUi.Modifiers.Offset do
  use LiveViewNativePlatform.Modifier

  modifier_schema "offset" do
    field :x, :float
    field :y, :float
  end
end
