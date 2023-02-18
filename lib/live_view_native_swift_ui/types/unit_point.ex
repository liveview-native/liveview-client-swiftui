defmodule LiveViewNativeSwiftUi.Types.UnitPoint do
  @derive Jason.Encoder
  defstruct [:x, :y]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_map(value) or is_list(value), do: {:ok, struct(__MODULE__, value)}
  def cast({x, y}), do: {:ok, %__MODULE__{x: x, y: y}}
  def cast(_), do: :error
end
