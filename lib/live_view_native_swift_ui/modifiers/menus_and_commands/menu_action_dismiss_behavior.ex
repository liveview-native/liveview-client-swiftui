defmodule LiveViewNativeSwiftUi.Modifiers.MenuActionDismissBehavior do
  use LiveViewNativePlatform.Modifier

  modifier_schema "menu_action_dismiss_behavior" do
    field(:behavior, Ecto.Enum, values: ~w(automatic enabled disabled)a)
  end

  def params(behavior) when is_atom(behavior) and not is_boolean(behavior) and not is_nil(behavior), do: [behavior: behavior]
  def params(params), do: params
end
