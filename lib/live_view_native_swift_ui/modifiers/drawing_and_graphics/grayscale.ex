defmodule LiveViewNativeSwiftUi.Modifiers.Grayscale do
  use LiveViewNativePlatform.Modifier

  modifier_schema "grayscale" do
    field :amount, :float
  end
end
