defmodule LiveViewNativeSwiftUi.Modifiers.Fill do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{ShapeStyle, FillStyle}

  modifier_schema "fill" do
    field :content, ShapeStyle
    field :style, FillStyle
  end
end
