defmodule LiveViewNativeSwiftUi.Modifiers.ToolbarRole do
  use LiveViewNativePlatform.Modifier

  modifier_schema "toolbar_role" do
    field :role, Ecto.Enum, values: ~w(automatic browser editor navigation_stack)a
  end
end
