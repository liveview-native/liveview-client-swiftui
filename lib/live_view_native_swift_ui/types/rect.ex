defmodule LiveViewNativeSwiftUi.Types.Rect do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: {:array, {:array, :number}}

  def cast([x, y, width, height]) when is_number(x) and is_number(y) and is_number(width) and is_number(height) do
    {:ok, [[x, y], [width, height]]}
  end
  def cast([[_, _], [_, _]] = value), do: {:ok, value}
  def cast(value) when is_map(value) or is_list(value), do: {:ok, [[value[:x], value[:y]], [value[:width], value[:height]]]}

  def cast(_), do: :error
end
