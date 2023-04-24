defmodule LiveViewNativeSwiftUi.Modifiers.ListRowBackground do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.KeyName

  modifier_schema "list_row_background" do
    field :content, KeyName
  end
end
