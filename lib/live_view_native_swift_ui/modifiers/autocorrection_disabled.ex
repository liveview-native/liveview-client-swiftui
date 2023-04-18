defmodule LiveViewNativeSwiftUi.Modifiers.AutocorrectionDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "autocorrection_disabled" do
    field :disable, :boolean, default: true
  end
end
