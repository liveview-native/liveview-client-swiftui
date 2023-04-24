defmodule LiveViewNativeSwiftUi.Modifiers.RenameAction do
  use LiveViewNativePlatform.Modifier

  modifier_schema "rename_action" do
    field :event, :string
    field :target, :integer
  end
end
