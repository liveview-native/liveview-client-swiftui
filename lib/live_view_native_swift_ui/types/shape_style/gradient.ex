defmodule LiveViewNativeSwiftUi.Types.Gradient do
  @derive Jason.Encoder
  defstruct [:colors, :stops]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Color
  alias LiveViewNativeSwiftUi.Types.Gradient.Stop

  def cast({:colors, colors}) when is_list(colors) do
    Enum.reduce(colors, {:ok, %__MODULE__{colors: []}}, fn color, acc ->
      with {:ok, %__MODULE__{colors: gradient_colors} = gradient} <- acc,
           {:ok, cast_color} <- Color.cast(color)
      do
        {:ok, %__MODULE__{gradient | colors: gradient_colors ++ [cast_color]}}
      else
        _ ->
          :error
      end
    end)
  end

  def cast({:stops, stops}) when is_list(stops) do
    Enum.reduce(stops, {:ok, %__MODULE__{stops: []}}, fn stop, acc ->
      with {:ok, %__MODULE__{stops: gradient_stops} = gradient} <- acc,
           {:ok, cast_stop} <- Stop.cast(stop)
      do
        {:ok, %__MODULE__{gradient | stops: gradient_stops ++ [cast_stop]}}
      else
        _ ->
          :error
      end
    end)
  end

  def cast(value) when is_map(value) or is_list(value), do: {:ok, struct(__MODULE__, value)}
  def cast(_), do: :error
end
