defmodule LiveViewNativeSwiftUi.Modifiers.DeleteDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "delete_disabled" do
    field :is_disabled, :boolean
  end
end
