defmodule LiveViewNativeSwiftUi.Modifiers.ListRowInsets do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeInsets

  modifier_schema "list_row_insets" do
    field :insets, EdgeInsets
  end
end
