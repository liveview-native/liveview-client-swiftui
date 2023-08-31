defmodule LiveViewNativeSwiftUi.Modifiers.ButtonBorderShape do
  use LiveViewNativePlatform.Modifier

  modifier_schema "button_border_shape" do
    field(:shape, Ecto.Enum, values: ~w(automatic capsule rounded_rectangle)a)
    field(:radius, :float, default: nil)
  end

  def params(shape) when is_atom(shape) and not is_boolean(shape) and not is_nil(shape), do: [shape: shape]
  def params(params), do: params
end
