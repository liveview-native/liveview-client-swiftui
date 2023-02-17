defmodule LiveViewNativeSwiftUi.Types.Color do
  defstruct [
    :blue,
    :brightness,
    :cg_color,
    :green,
    :hue,
    :ns_color,
    :opacity,
    :red,
    :rgb_color_space,
    :saturation,
    :string,
    :type,
    :ui_color,
    :white
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_map(value), do: {:ok, struct(__MODULE__, value)}
  def cast(value) when is_bitstring(value), do: {:ok, %__MODULE__{type: :string, string: value}}
  def cast({:ui_color, ui_color}), do: {:ok, %__MODULE__{type: :ui_color, ui_color: ui_color}}
  def cast({:ns_color, ns_color}), do: {:ok, %__MODULE__{type: :ns_color, ns_color: ns_color}}
  def cast({:cg_color, cg_color}), do: {:ok, %__MODULE__{type: :cg_color, cg_color: cg_color}}
  def cast(_), do: :error
end
