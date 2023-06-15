defmodule LiveViewNativeSwiftUi.Modifiers.Opacity do
  use LiveViewNativePlatform.Modifier

  modifier_schema "opacity" do
    field :opacity, :float
  end

  def params(opacity) when is_float(opacity), do: [opacity: opacity]
  def params(params), do: params
end
