defmodule LiveViewNativeSwiftUi.Modifiers.Brightness do
  use LiveViewNativePlatform.Modifier

  modifier_schema "brightness" do
    field :amount, :float
  end
end
