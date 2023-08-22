defmodule LiveViewNativeSwiftUi.Modifiers.Draggable do
  alias LiveViewNativeSwiftUi.Types.KeyName
  use LiveViewNativePlatform.Modifier

  modifier_schema "draggable" do
    field :payload, :string
    field :preview, KeyName
  end

  def params(payload, [preview: preview]), do: [payload: payload, preview: preview]
  def params(payload) when is_binary(payload), do: [payload: payload, preview: nil]
  def params(params), do: params
end
