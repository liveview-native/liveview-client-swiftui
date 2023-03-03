defmodule LiveViewNativeSwiftUi.Modifiers.Background do
  use LiveViewNativePlatform.Modifier

  modifier_schema "background" do
    field :shape, :string
  end
end
