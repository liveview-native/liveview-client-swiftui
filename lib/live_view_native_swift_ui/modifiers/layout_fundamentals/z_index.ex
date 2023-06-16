defmodule LiveViewNativeSwiftUi.Modifiers.ZIndex do
  use LiveViewNativePlatform.Modifier

  modifier_schema "z_index" do
    field :value, :float
  end

  def params(z_index) when is_float(z_index), do: [z_index: z_index]
  def params(params), do: params
end
