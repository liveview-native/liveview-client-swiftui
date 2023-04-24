defmodule LiveViewNativeSwiftUi.Modifiers.Tint do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Color

  modifier_schema "tint" do
    field :color, Color
  end
end
