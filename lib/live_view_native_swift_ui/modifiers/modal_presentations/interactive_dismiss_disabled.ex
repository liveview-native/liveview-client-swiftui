defmodule LiveViewNativeSwiftUi.Modifiers.InteractiveDismissDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "interactive_dismiss_disabled" do
    field(:disabled, :boolean, default: true)
  end
end
