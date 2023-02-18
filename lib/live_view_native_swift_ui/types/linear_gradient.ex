defmodule LiveViewNativeSwiftUi.Types.LinearGradient do
  @derive Jason.Encoder
  defstruct [
    :gradient,
    start_point: {0, 0},
    end_point: {1, 1}
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Gradient
  alias LiveViewNativeSwiftUi.Types.UnitPoint

  def cast(value) when is_map(value) or is_list(value) do
    with {:ok, gradient} <- Gradient.cast(value[:gradient]),
         {:ok, start_point} <- UnitPoint.cast(value[:start_point] || {0, 0}),
         {:ok, end_point} <- UnitPoint.cast(value[:end_point] || {1, 1})
    do
      {:ok, %__MODULE__{
        gradient: gradient,
        start_point: start_point,
        end_point: end_point
      }}
    else
      _ ->
        :error
    end
  end

  def cast(_), do: :error
end
