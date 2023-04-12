defmodule LiveViewNativeSwiftUi.Modifiers.Bold do
  use LiveViewNativePlatform.Modifier

  modifier_schema "bold" do
    field :is_active, :boolean, default: true
  end
end
