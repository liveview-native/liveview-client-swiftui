defmodule LiveViewNativeSwiftUi.Modifiers.MoveDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "move_disabled" do
    field :is_disabled, :boolean
  end
end
