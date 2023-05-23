defmodule LiveViewNativeSwiftUi.Modifiers.FocusScope do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Namespace

  modifier_schema "focus_scope" do
    field :namespace, Namespace
  end
end
