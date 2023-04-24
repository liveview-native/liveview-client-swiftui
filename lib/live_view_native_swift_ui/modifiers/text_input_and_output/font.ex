defmodule LiveViewNativeSwiftUi.Modifiers.Font do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Font

  modifier_schema "font" do
    field :font, Font
  end
end
