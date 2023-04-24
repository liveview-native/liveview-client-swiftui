defmodule LiveViewNativeSwiftUi.Modifiers.Italic do
  use LiveViewNativePlatform.Modifier

  modifier_schema "italic" do
    field :is_active, :boolean, default: true
  end
end
