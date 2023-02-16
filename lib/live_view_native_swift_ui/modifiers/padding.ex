defmodule LiveViewNativeSwiftUi.Modifiers.Padding do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeInsets

  modifier_schema "padding" do
    field :all, :float
    field :insets, EdgeInsets
  end
end
