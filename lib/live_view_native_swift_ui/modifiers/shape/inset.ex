defmodule LiveViewNativeSwiftUi.Modifiers.Inset do
  use LiveViewNativePlatform.Modifier

  modifier_schema "inset" do
    field :amount, :float
  end
end
