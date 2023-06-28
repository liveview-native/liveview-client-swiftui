defmodule LiveViewNativeSwiftUi.Modifiers.ControlSize do
  use LiveViewNativePlatform.Modifier

  modifier_schema "control_size" do
    field(:size, Ecto.Enum, values: ~w(mini small regular large)a)
  end

  def params(size) when is_atom(size) and not is_boolean(size) and not is_nil(size), do: [size: size]
  def params(params), do: params
end
