defmodule LiveViewNativeSwiftUi.Modifiers.StatusBarHidden do
  use LiveViewNativePlatform.Modifier

  modifier_schema "status_bar_hidden" do
    field :hidden, :boolean
  end

  def params(hidden) when is_boolean(hidden), do: [hidden: hidden]
  def params(params), do: params
end
