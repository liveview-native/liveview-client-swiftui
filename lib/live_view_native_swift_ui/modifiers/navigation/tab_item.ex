defmodule LiveViewNativeSwiftUi.Modifiers.TabItem do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "tab_item" do
    field :label, KeyName
  end
end
