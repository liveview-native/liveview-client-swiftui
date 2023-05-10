defmodule LiveViewNativeSwiftUi.Modifiers.SubmitScope do
  use LiveViewNativePlatform.Modifier

  modifier_schema "submit_scope" do
    field :is_blocking, :boolean, default: true
  end
end
