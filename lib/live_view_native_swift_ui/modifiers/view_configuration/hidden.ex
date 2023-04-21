defmodule LiveViewNativeSwiftUi.Modifiers.Hidden do
  use LiveViewNativePlatform.Modifier

  modifier_schema "hidden" do
    field :is_active, :boolean
  end
end
