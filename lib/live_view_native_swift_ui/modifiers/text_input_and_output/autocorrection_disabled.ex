defmodule LiveViewNativeSwiftUi.Modifiers.AutocorrectionDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "autocorrection_disabled" do
    field :disable, :boolean, default: true
  end

  def params(disable) when is_boolean(disable), do: [disable: disable]
  def params(params), do: params
end
