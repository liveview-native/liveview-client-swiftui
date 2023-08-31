defmodule LiveViewNativeSwiftUi.Modifiers.InteractiveDismissDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "interactive_dismiss_disabled" do
    field(:disabled, :boolean, default: true)
  end

  def params(disabled) when is_boolean(disabled), do: [disabled: disabled]
  def params(params), do: params
end
