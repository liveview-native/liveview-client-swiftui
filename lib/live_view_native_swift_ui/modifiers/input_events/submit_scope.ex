defmodule LiveViewNativeSwiftUi.Modifiers.SubmitScope do
  use LiveViewNativePlatform.Modifier

  modifier_schema "submit_scope" do
    field :is_blocking, :boolean, default: true
  end

  def params(is_blocking) when is_boolean(is_blocking), do: [is_blocking: is_blocking]
  def params(params), do: params
end
