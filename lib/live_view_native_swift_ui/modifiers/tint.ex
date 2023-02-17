defmodule LiveViewNativeSwiftUi.Modifiers.Tint do
  use LiveViewNativePlatform.Modifier

  modifier_schema "tint" do
    field :color, :string
  end
end
