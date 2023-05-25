defmodule LiveViewNativeSwiftUi.Modifiers.Focusable do
  use LiveViewNativePlatform.Modifier

  modifier_schema "focusable" do
    field :is_focusable, :boolean, default: true
  end
end
