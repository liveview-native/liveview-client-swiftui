defmodule LiveViewNativeSwiftUi.Modifiers.BackgroundStyle do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "background_style" do
    field :style, ShapeStyle
  end
end
