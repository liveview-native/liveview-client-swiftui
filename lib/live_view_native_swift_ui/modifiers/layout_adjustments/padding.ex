defmodule LiveViewNativeSwiftUi.Modifiers.Padding do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeInsets
  alias LiveViewNativeSwiftUi.Types.EdgeSet

  modifier_schema "padding" do
    field :insets, EdgeInsets
    field :edges, EdgeSet
    field :length, :float
  end
end
