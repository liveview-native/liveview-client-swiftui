defmodule LiveViewNativeSwiftUi.Modifiers.ForegroundColor do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "foreground_color" do
    field :color, Color
  end
end
