defmodule LiveViewNativeSwiftUi.Modifiers.Antialiased do
  use LiveViewNativePlatform.Modifier

  modifier_schema "antialiased" do
    field :is_active, :boolean, default: true
  end
end
