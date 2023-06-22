defmodule LiveViewNativeSwiftUi.Modifiers.ControlSize do
  use LiveViewNativePlatform.Modifier

  modifier_schema "control_size" do
    field(:size, Ecto.Enum, values: ~w(mini small regular large)a)
  end

  def params(size) when is_atom(size), do: [size: size]
  def params(params), do: params
end
