defmodule LiveViewNativeSwiftUi.Modifiers.StrokeBorder do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{ShapeStyle, StrokeStyle}

  modifier_schema "stroke_border" do
    field :content, ShapeStyle
    field :style, StrokeStyle
    field :antialiased, :boolean, default: true
  end
end
