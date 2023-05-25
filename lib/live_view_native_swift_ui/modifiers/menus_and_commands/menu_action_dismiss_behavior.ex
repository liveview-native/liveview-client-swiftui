defmodule LiveViewNativeSwiftUi.Modifiers.MenuActionDismissBehavior do
  use LiveViewNativePlatform.Modifier

  modifier_schema "menu_action_dismiss_behavior" do
    field(:behavior, Ecto.Enum, values: ~w(automatic enabled disabled)a)
  end
end
