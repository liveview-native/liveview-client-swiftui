defmodule LiveViewNativeSwiftUi.Modifiers.Italic do
  use LiveViewNativePlatform.Modifier

  modifier_schema "italic" do
    field :active, :boolean
  end
end
