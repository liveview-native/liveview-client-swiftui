defmodule LiveViewNativeSwiftUi.Types.ShadowStyle do
  @derive Jason.Encoder
  defstruct [
    :type,
    :color,
    :radius,
    :x,
    :y
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Color

  def cast({type, opts}) when type in [:drop, :inner] and is_map(opts) or is_list(opts) do
    with_type = opts
      |> Enum.into(%{})
      |> Map.put(:type, type)
    {:ok, struct(
      __MODULE__,
      (if Map.has_key?(with_type, :color),
        do: Map.replace(with_type, :color, elem(Color.cast(with_type[:color]), 1)),
        else: with_type
      )
    )}
  end
  def cast(_), do: :error
end
