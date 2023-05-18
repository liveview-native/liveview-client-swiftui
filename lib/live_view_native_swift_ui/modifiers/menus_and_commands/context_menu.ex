defmodule LiveViewNativeSwiftUi.Modifiers.ContextMenu do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "context_menu" do
    field(:menu_items, KeyName)
    field(:preview, KeyName, default: nil)
  end
end
