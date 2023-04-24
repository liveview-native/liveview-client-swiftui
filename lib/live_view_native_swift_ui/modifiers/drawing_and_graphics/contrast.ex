defmodule LiveViewNativeSwiftUi.Modifiers.Contrast do
  use LiveViewNativePlatform.Modifier

  modifier_schema "contrast" do
    field :amount, :float
  end
end
