defmodule LiveViewNativeSwiftUi.Types.UnitPoint do
  @derive Jason.Encoder
  defstruct [:x, :y, :named]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  @static_members [
    :zero,
    :center,
    :leading,
    :trailing,
    :top,
    :bottom,
    :top_leading,
    :top_trailing,
    :bottom_leading,
    :bottom_trailing
  ]

  def cast(value) when value in @static_members, do: {:ok, %__MODULE__{named: Atom.to_string(value)}}
  def cast(value) when is_map(value) or is_list(value), do: {:ok, struct(__MODULE__, value)}
  def cast({x, y}), do: {:ok, %__MODULE__{x: x, y: y}}
  def cast(_), do: :error
end
