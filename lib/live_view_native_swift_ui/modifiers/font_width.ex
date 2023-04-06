defmodule LiveViewNativeSwiftUi.Modifiers.FontWidth do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.FontWidth

  modifier_schema "font_width" do
    field :width, FontWidth
  end
end
