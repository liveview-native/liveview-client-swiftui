defmodule LiveViewNativeSwiftUi.Modifiers.ToolbarRole do
  use LiveViewNativePlatform.Modifier

  modifier_schema "toolbar_role" do
    field :role, Ecto.Enum, values: ~w(automatic browser editor navigation_stack)a
  end

  def params(role) when is_atom(role) and not is_boolean(role) and not is_nil(role), do: [role: role]
  def params(params), do: params
end
