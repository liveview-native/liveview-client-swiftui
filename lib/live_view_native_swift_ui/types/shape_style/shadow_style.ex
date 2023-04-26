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
    with_type =
      opts
      |> Enum.into(%{})
      |> Map.put(:type, type)

    {:ok, struct(__MODULE__, cast_color(with_type))}
  end

  def cast(_), do: :error

  ###

  defp cast_color(%{color: color} = with_type) do
    cast_color = Color.cast(color)

    Map.replace(with_type, :color, elem(cast_color, 1))
  end

  defp cast_color(with_type), do: with_type
