defmodule LiveViewNativeSwiftUi.Types.Rect do
  @derive Jason.Encoder

  use LiveViewNativePlatform.Modifier.Type
  def type, do: {:array, {:array, :number}}

  def cast([x, y, width, height]) when is_float(x) and is_float(y) and is_float(width) and is_float(height) do
    {:ok, [[x, y], [width, height]]}
  end
  def cast([[_, _], [_, _]] = value), do: {:ok, value}
  def cast(value) when is_map(value) or is_list(value), do: {:ok, [[value[:x], value[:y]], [value[:width], value[:height]]]}

  def cast(_), do: :error
end
