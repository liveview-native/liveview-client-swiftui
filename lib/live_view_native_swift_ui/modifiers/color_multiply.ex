defmodule LiveViewNativeSwiftUi.Modifiers.ColorMultiply do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "color_multiply" do
    field :color, Color
  end
end
