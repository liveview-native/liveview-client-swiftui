defmodule LiveViewNativeSwiftUi.Modifiers.Disabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "disabled" do
    field :disabled, :boolean
  end
end
