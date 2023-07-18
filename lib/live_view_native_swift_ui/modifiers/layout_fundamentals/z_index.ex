defmodule LiveViewNativeSwiftUi.Modifiers.ZIndex do
  use LiveViewNativePlatform.Modifier

  modifier_schema "z_index" do
    field :value, :float
  end

  def params(value) when is_number(value), do: [value: value]
  def params(params), do: params
end
