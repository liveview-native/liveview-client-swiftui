defmodule LiveViewNativeSwiftUi.Modifiers.Resizable do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.EdgeInsets

  modifier_schema "resizable" do
    field :cap_insets, EdgeInsets
    field :resizing_mode, Ecto.Enum, values: ~w(stretch tile)a, default: :stretch
  end
end
