defmodule LiveViewNativeSwiftUi.Modifiers.ListItemTint do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ListItemTint

  modifier_schema "list_item_tint" do
    field :tint, ListItemTint
  end
end
