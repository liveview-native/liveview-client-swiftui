defmodule LiveViewNativeSwiftUi.Modifiers.Monospaced do
  use LiveViewNativePlatform.Modifier

  modifier_schema "monospaced" do
    field :is_active, :boolean, default: true
  end
end
