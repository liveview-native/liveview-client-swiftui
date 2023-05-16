defmodule LiveViewNativeSwiftUi.Modifiers.ClipShape do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{Shape, FillStyle}

  modifier_schema "clip_shape" do
    field :shape, Shape
    field :style, FillStyle
  end
end
