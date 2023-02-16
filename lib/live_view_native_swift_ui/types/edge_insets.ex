defmodule LiveViewNativeSwiftUi.Types.EdgeInsets do
  defstruct [:top, :bottom, :leading, :trailing]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_map(value) or is_list(value), do: {:ok, struct(__MODULE__, value)}
  def cast(_), do: :error
end
