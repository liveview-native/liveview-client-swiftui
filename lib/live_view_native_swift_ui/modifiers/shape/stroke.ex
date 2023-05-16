defmodule LiveViewNativeSwiftUi.Modifiers.Stroke do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{ShapeStyle, StrokeStyle}

  modifier_schema "stroke" do
    field :content, ShapeStyle
    field :style, StrokeStyle
  end
end
