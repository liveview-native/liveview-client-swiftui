defmodule LiveViewNativeSwiftUi.Modifiers.ForegroundStyle do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "foreground_style" do
    field :primary, ShapeStyle
    field :secondary, ShapeStyle
    field :tertiary, ShapeStyle
  end
end
