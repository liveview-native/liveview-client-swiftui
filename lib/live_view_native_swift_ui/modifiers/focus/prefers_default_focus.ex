defmodule LiveViewNativeSwiftUi.Modifiers.PrefersDefaultFocus do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Namespace

  modifier_schema "prefers_default_focus" do
    field :prefers_default_focus, :boolean, default: true
    field :namespace, Namespace
  end

  def params(prefers_default_focus, [in: namespace]), do: [prefers_default_focus: prefers_default_focus, namespace: namespace]
  def params([in: namespace]), do: [namespace: namespace]
  def params(params), do: params
end
