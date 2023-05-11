defmodule LiveViewNativeSwiftUi.Modifiers.Fill do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "fill" do
    field :style, ShapeStyle
  end
end
