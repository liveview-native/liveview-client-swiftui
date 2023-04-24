defmodule LiveViewNativeSwiftUi.Modifiers.Border do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "border" do
    field :content, ShapeStyle
    field :width, :float, default: 0.0
  end
end
