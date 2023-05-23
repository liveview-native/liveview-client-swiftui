defmodule LiveViewNativeSwiftUi.Modifiers.PrefersDefaultFocus do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Namespace

  modifier_schema "prefers_default_focus" do
    field :prefers_default_focus, :boolean, default: true
    field :namespace, Namespace
  end
end
