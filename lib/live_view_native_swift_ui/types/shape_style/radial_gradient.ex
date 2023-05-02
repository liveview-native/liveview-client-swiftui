defmodule LiveViewNativeSwiftUi.Types.RadialGradient do
  @derive Jason.Encoder
  defstruct [
    :gradient,
    :start_radius,
    :end_radius,
    center: {0.5, 0.5}
  ]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  alias LiveViewNativeSwiftUi.Types.Gradient
  alias LiveViewNativeSwiftUi.Types.UnitPoint

  def cast(value) when is_map(value) or is_list(value) do
    with {:ok, gradient} <- Gradient.cast(value[:gradient]),
         {:ok, center} <- UnitPoint.cast(value[:center] || {0.5, 0.5})
    do
      {:ok, %__MODULE__{
        gradient: gradient,
        center: center,
        start_radius: value[:start_radius],
        end_radius: value[:end_radius]
      }}
    else
      _ ->
        :error
    end
  end

  def cast(_), do: :error
end
