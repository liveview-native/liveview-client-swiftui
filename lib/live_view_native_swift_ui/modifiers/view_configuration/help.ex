defmodule LiveViewNativeSwiftUi.Modifiers.Help do
  use LiveViewNativePlatform.Modifier

  modifier_schema "help" do
    field :text, :string
  end
end
