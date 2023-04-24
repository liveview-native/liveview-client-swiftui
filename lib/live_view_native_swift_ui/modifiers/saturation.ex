defmodule LiveViewNativeSwiftUi.Modifiers.Saturation do
  use LiveViewNativePlatform.Modifier

  modifier_schema "saturation" do
    field :amount, :float
  end
end
